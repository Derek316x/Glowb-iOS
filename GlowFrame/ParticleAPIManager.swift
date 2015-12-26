//
//  APIManager.swift
//  GlowFrame
//
//  Created by Michael Kavouras on 12/7/15.
//  Copyright © 2015 Michael Kavouras. All rights reserved.
//

import Foundation
import Alamofire

class ParticleAPIManager {
    
    private class var defaultParams: [String: String] {
        return ["access_token" : accessToken]
    }
    
    private class var accessToken: String! {
        let path = NSBundle.mainBundle().pathForResource("Keys", ofType: "plist")!
        let plist = NSDictionary(contentsOfFile: path)!
        let token = plist["ParticleAccessToken"] as! String
        return token
    }
    
    class func fetchDeviceInfo(deviceID: String, completion: (info: [String: AnyObject]) -> Void) -> NSURLSessionTask
    {
        let url = ParticleEndpoints.DeviceInfo(deviceID).URL()
        
        let request = Alamofire.request(.GET, url, parameters: defaultParams, encoding: .URL, headers: nil).responseJSON { (response: Response<AnyObject, NSError>) -> Void in
            
            if response.result.isSuccess {
                if let value = response.result.value as? [String: AnyObject] {
                    completion(info: value)
                }
            }
        }
        
        return request.task
    }
    
    class func callFunction(name: String, forDevice deviceID: String, withArgs args: String, completion: (success: Bool) -> Void) -> Request
    {
        let url = ParticleEndpoints.CallFunction(deviceID, name).URL()
        
        var params = defaultParams
        params["args"] = args
        
        return Alamofire.request(.POST, url, parameters: params, encoding: .URL, headers: nil).responseJSON { (response: Response<AnyObject, NSError>) -> Void in
            print(response.result.value)
        }
    }
}

typealias DeviceID = String
typealias FunctionName = String

enum ParticleEndpoints {
    
    case DeviceInfo(DeviceID)
    case CallFunction(DeviceID, FunctionName)
    
    func URL() -> NSURL {
        switch self {
        case .DeviceInfo(let id):
            return NSURL(string: "\(devicesURL())/\(id)")!
        case .CallFunction(let id, let function):
            return NSURL(string: "\(devicesURL())/\(id)/\(function)")!
        }
    }
    
    private func devicesURL() -> NSString {
        return "\(APIBase())/\(APIVersion())/devices"
    }
    
    private func APIBase() -> NSString {
        return "https://api.particle.io"
    }
    
    private func APIVersion() -> NSString {
        return "v1"
    }
}