//
//  SparkDevice.m
//  mobile-sdk-ios
//
//  Created by Ido Kleinman on 11/7/14.
//  Copyright (c) 2014-2015 Spark. All rights reserved.
//

#import "SparkDevice.h"
#import "SparkCloud.h"
#import <AFNetworking/AFNetworking.h>
#import <objc/runtime.h>

#define MAX_SPARK_FUNCTION_ARG_LENGTH 63

@interface SparkDevice()
@property (strong, nonatomic) NSString* id;
@property (nonatomic) BOOL connected; // might be impossible
@property (strong, nonatomic) NSArray *functions;
@property (strong, nonatomic) NSDictionary *variables;
@property (strong, nonatomic) NSString *version;
@property (nonatomic) SparkDeviceType type;
@property (nonatomic) BOOL requiresUpdate;
@property (nonatomic, strong) AFHTTPSessionManager *manager;
@property (atomic) NSInteger flashingTimeLeft;
@property (nonatomic, strong) NSTimer *flashingTimer;
@property (nonatomic, strong) NSURL *baseURL;
@end

@implementation SparkDevice

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    NSString *id = [aDecoder decodeObjectForKey:@"id"];
    SparkDevice *device = [self initWithParams:@{@"id" : id}];

    device.name = [aDecoder decodeObjectForKey:@"name"];
    device.connected = [[aDecoder decodeObjectForKey:@"connected"] boolValue];
    device.functions = [aDecoder decodeObjectForKey:@"functions"];
    device.variables = [aDecoder decodeObjectForKey:@"variables"];
    device.type = [[aDecoder decodeObjectForKey:@"type"] integerValue];
    
    return device;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.id forKey:@"id"];
    [coder encodeObject:[NSNumber numberWithBool:self.connected] forKey:@"connected"];

    if (self.name)
    {
        [coder encodeObject:self.name forKey:@"name"];
    }

    if (self.functions)
    {
        [coder encodeObject:self.functions forKey:@"functions"];
    }

    if (self.variables)
    {
        [coder encodeObject:self.variables forKey:@"variables"];
    }

    if (self.type)
    {
        [coder encodeObject:[NSNumber numberWithInteger:self.type] forKey:@"type"];
    }

}

-(instancetype)initWithParams:(NSDictionary *)params
{
    if (self = [super init])
    {
        self.baseURL = [NSURL URLWithString:kSparkAPIBaseURL];

        self.requiresUpdate = NO;

        _name = nil;
        if (![params[@"name"] isKindOfClass:[NSNull class]] && params[@"name"])
        {
            _name = params[@"name"];
        }

        self.connected = [params[@"connected"] boolValue] == YES;

        if (params[@"functions"])
        {
            self.functions = params[@"functions"];
        }

        if (params[@"variables"])
        {
            self.variables = params[@"variables"];
        }

        _id = params[@"id"];

        _type = SparkDeviceTypePhoton;
        if (![params[@"product_id"] isKindOfClass:[NSNull class]])
        {
            if (params[@"product_id"])
            {
                if ([params[@"product_id"] intValue]==SparkDeviceTypeCore)
                {
                    _type = SparkDeviceTypeCore;
                }
                if ([params[@"product_id"] intValue]==SparkDeviceTypeElectron)
                {
                    _type = SparkDeviceTypeElectron;
                }
            }
        }


        if (![params[@"last_app"] isKindOfClass:[NSNull class]])
        {
            if (params[@"last_app"])
            {
                _lastApp = params[@"last_app"];
            }
        }

        if (![params[@"last_heard"] isKindOfClass:[NSNull class]])
        {
            if (params[@"last_heard"])
            {
                // TODO: add to utils class as POSIX time to NSDate
                NSString *dateString = params[@"last_heard"];// "2015-04-18T08:42:22.127Z"
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
                NSLocale *posix = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
                [formatter setLocale:posix];
                _lastHeard = [formatter dateFromString:dateString];
            }
        }

        /*
         // Inactive for now // TODO: re-enable when we can distinguish devices in the cloud
        if (params[@"cc3000_patch_version"]) // check for other version indication strings - ask doc
        {
            self.type = SparkDeviceTypeCore;
            self.version = (params[@"cc3000_patch_version"]);
        }
         */

        if (params[@"device_needs_update"])
        {
            self.requiresUpdate = YES;
        }

        self.manager = [[AFHTTPSessionManager alloc] initWithBaseURL:self.baseURL];
        self.manager.responseSerializer = [AFJSONResponseSerializer serializer];

        if (!self.manager) return nil;

        return self;
    }

    return nil;
}


-(NSURLSessionDataTask *)refresh:(void(^)(NSError* error))completion;
{
    return [[SparkCloud sharedInstance] getDevice:self.id completion:^(SparkDevice *updatedDevice, NSError *error) {
        if (!error)
        {
            if (updatedDevice)
            {
                // if we got an updated device from the cloud - overwrite ALL self's properies with the new device properties
                NSMutableSet *propNames = [NSMutableSet set];
                unsigned int outCount, i;
                objc_property_t *properties = class_copyPropertyList([updatedDevice class], &outCount);
                for (i = 0; i < outCount; i++) {
                    objc_property_t property = properties[i];
                    NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSStringEncodingConversionAllowLossy];
                    [propNames addObject:propertyName];
                }
                free(properties);

                for (NSString *property in propNames)
                {
                    id value = [updatedDevice valueForKey:property];
                    [self setValue:value forKey:property];
                }
            }
            if (completion)
            {
                completion(nil);
            }
        }
        else
        {
            if (completion)
            {
                completion(error);
            }
        }
    }];
}

-(NSURLSessionDataTask *)getVariable:(NSString *)variableName
        completion:(void(^)(id result, NSError* error))completion
{
    // TODO: check variable name exists in list
    // TODO: check response of calling a non existant function

    NSURL *url = [self.baseURL URLByAppendingPathComponent:[NSString stringWithFormat:@"v1/devices/%@/%@", self.id, variableName]];

    [self setAuthHeaderWithAccessToken];

    NSURLSessionDataTask *task = [self.manager GET:[url description] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        if (completion)
        {
            NSDictionary *responseDict = responseObject;
            if ([responseDict[@"coreInfo"][@"connected"] boolValue]==NO) // check response
            {
                NSError *err = [self makeErrorWithDescription:@"Device is not connected" code:1001];
                completion(nil,err);
            }
            else
            {
                // check
                completion(responseDict[@"result"],nil);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
        if (completion)
        {
            completion(nil,error);
        }
    }];

    return task;
}

-(NSURLSessionDataTask *)callFunction:(NSString *)functionName
      withArguments:(NSArray *)args
         completion:(void (^)(NSNumber *, NSError *))completion
{
    // TODO: check function name exists in list
    // TODO: check response of calling a non existant function

    NSURL *url = [self.baseURL URLByAppendingPathComponent:[NSString stringWithFormat:@"v1/devices/%@/%@", self.id, functionName]];
    NSMutableDictionary *params = [NSMutableDictionary new]; //[self defaultParams];

    if (args) {
        NSMutableArray *argsStr = [[NSMutableArray alloc] initWithCapacity:args.count];
        for (id arg in args)
        {
            [argsStr addObject:[arg description]];
        }
        NSString *argsValue = [argsStr componentsJoinedByString:@","];
        if (argsValue.length > MAX_SPARK_FUNCTION_ARG_LENGTH)
        {
            // TODO: arrange user error/codes in a list
            NSError *err = [self makeErrorWithDescription:[NSString stringWithFormat:@"Maximum argument length cannot exceed %d",MAX_SPARK_FUNCTION_ARG_LENGTH] code:1000];
            if (completion)
                completion(nil,err);
            return nil;
        }

        params[@"args"] = argsValue;
    }

    [self setAuthHeaderWithAccessToken];

    NSURLSessionDataTask *task = [self.manager POST:[url description] parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        if (completion)
        {
            NSDictionary *responseDict = responseObject;
            if ([responseDict[@"connected"] boolValue]==NO)
            {
                NSError *err = [self makeErrorWithDescription:@"Device is not connected" code:1001];
                completion(nil,err);
            }
            else
            {
                // check
                NSNumber *result = responseDict[@"return_value"];
                completion(result,nil);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
        if (completion)
        {
            completion(nil,error);
        }
    }];

    return task;
}



-(NSURLSessionDataTask *)unclaim:(void (^)(NSError *))completion
{

    NSURL *url = [self.baseURL URLByAppendingPathComponent:[NSString stringWithFormat:@"v1/devices/%@", self.id]];

//    NSMutableDictionary *params = [self defaultParams];
//    params[@"id"] = self.id;
    [self setAuthHeaderWithAccessToken];

    NSURLSessionDataTask *task = [self.manager DELETE:[url description] parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        if (completion)
        {
            NSDictionary *responseDict = responseObject;
            if ([responseDict[@"ok"] boolValue])
                completion(nil);
            else
                completion([self makeErrorWithDescription:@"Could not unclaim device" code:1003]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
         if (completion)
         {
             completion(error);
         }
    }];

    return task;
}

-(NSURLSessionDataTask *)rename:(NSString *)newName completion:(void(^)(NSError* error))completion
{
    NSURL *url = [self.baseURL URLByAppendingPathComponent:[NSString stringWithFormat:@"v1/devices/%@", self.id]];

    // TODO: check name validity before calling API
    NSMutableDictionary *params = [NSMutableDictionary new];// [self defaultParams];
    params[@"name"] = newName;
    [self setAuthHeaderWithAccessToken];


    NSURLSessionDataTask *task = [self.manager PUT:[url description] parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        _name = newName;
        if (completion)
        {
            completion(nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         if (completion) // TODO: better erroring handling
         {
             completion(error);
         }
    }];

    return task;
}



#pragma mark Internal use methods
- (NSMutableDictionary *)defaultParams
{
    // TODO: change access token to be passed in header not in body
    if ([SparkCloud sharedInstance].accessToken)
    {
        return [@{@"access_token" : [SparkCloud sharedInstance].accessToken} mutableCopy];
    }
    else return nil;
}

-(void)setAuthHeaderWithAccessToken
{
    NSString *authorization = [NSString stringWithFormat:@"Bearer %@",[SparkCloud sharedInstance].accessToken];
    [self.manager.requestSerializer setValue:authorization forHTTPHeaderField:@"Authorization"];
}


-(NSError *)makeErrorWithDescription:(NSString *)desc code:(NSInteger)errorCode
{

    NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
    [errorDetail setValue:desc forKey:NSLocalizedDescriptionKey];
    return [NSError errorWithDomain:@"SparkAPIError" code:errorCode userInfo:errorDetail];
}



-(NSString *)description
{
    NSString *desc = [NSString stringWithFormat:@"<SparkDevice 0x%lx, type: %@, id: %@, name: %@, connected: %@, variables: %@, functions: %@, version: %@, requires update: %@, last app: %@, last heard: %@>",
                      (unsigned long)self,
                      (self.type == SparkDeviceTypeCore) ? @"Core" : @"Photon",
                      self.id,
                      self.name,
                      (self.connected) ? @"true" : @"false",
                      self.variables,
                      self.functions,
                      self.version,
                      (self.requiresUpdate) ? @"true" : @"false",
                      self.lastApp,
                      self.lastHeard];

    return desc;

}


-(NSURLSessionDataTask *)flashKnownApp:(NSString *)knownAppName
          completion:(void (^)(NSError *))completion
{
    NSURL *url = [self.baseURL URLByAppendingPathComponent:[NSString stringWithFormat:@"v1/devices/%@", self.id]];

    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"app"] = knownAppName;
    [self setAuthHeaderWithAccessToken];

    NSURLSessionDataTask *task = [self.manager PUT:[url description] parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        NSDictionary *responseDict = responseObject;
        if (responseDict[@"errors"])
        {
            if (completion)
            {
                completion([self makeErrorWithDescription:responseDict[@"errors"][@"error"] code:1005]);
            }
        }
        else
        {
            if (completion) {
                completion(nil);
            }
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
         if (completion) // TODO: better erroring handling
         {
             completion(error);
         }
    }];

    return task;
}

-(NSURLSessionDataTask *)flashFiles:(NSDictionary *)filesDict
       completion:(void (^)(NSError *))completion // binary
{
    NSURL *url = [self.baseURL URLByAppendingPathComponent:[NSString stringWithFormat:@"v1/devices/%@", self.id]];

    [self setAuthHeaderWithAccessToken];

    NSError *reqError;
    NSMutableURLRequest *request = [self.manager.requestSerializer multipartFormRequestWithMethod:@"PUT" URLString:url.description parameters:@{@"file_type" : @"binary"} constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        // check this:
        for (NSString *key in filesDict.allKeys)
        {
            [formData appendPartWithFileData:filesDict[key] name:@"file" fileName:key mimeType:@"application/octet-stream"];
        }
    } error:&reqError];

    if (!reqError)
    {
        NSURLSessionDataTask *task = [self.manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error)
        {
            if (error == nil)
            {
                NSDictionary *responseDict = responseObject;
    //            NSLog(@"flashFiles: %@",responseDict.description);
                if (responseDict[@"error"])
                {
                    if (completion)
                    {
                        completion([self makeErrorWithDescription:responseDict[@"error"] code:1004]);
                    }
                }
                else if (completion)
                {
                    completion(nil);
                }
            }
            else
            {
                // TODO: better erroring handlin
                if (completion)
                {
                    completion(error);
                }
            }
        }];

        return task;
    }
    else
    {
        if (completion)
        {
            completion(reqError);
        }
    }

    return nil;
}

-(void)flashingTimeLeftTimerFunc:(NSTimer *)timer
{
    if (self.flashingTimeLeft > 0)
    {
        self.flashingTimeLeft -= 1;
    }
    else
    {
        [timer invalidate];
    }
}

-(BOOL)isFlashing
{
    return (self.flashingTimeLeft > 0);
}

-(void)setIsFlashing:(BOOL)isFlashing
{
    // TODO: convert this to be working with a subscribe to start flash/end flash event instead of a dumb timer
    if (isFlashing)
    {
        self.flashingTimeLeft = (self.type == SparkDeviceTypePhoton) ? 15 : 30;
        self.flashingTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(flashingTimeLeftTimerFunc:) userInfo:nil repeats:YES];
    }
    else
    {
        self.flashingTimeLeft = 0;
    }
}


-(id)subscribeToEventsWithPrefix:(NSString *)eventNamePrefix
                         handler:(SparkEventHandler)eventHandler
{
    return [[SparkCloud sharedInstance] subscribeToDeviceEventsWithPrefix:eventNamePrefix deviceID:self.id handler:eventHandler];
}

-(void)unsubscribeFromEventWithID:(id)eventListenerID
{
    [[SparkCloud sharedInstance] unsubscribeFromEventWithID:eventListenerID];
}

@end
