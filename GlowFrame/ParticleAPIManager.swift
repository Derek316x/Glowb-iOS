//
//  APIManager.swift
//  GlowFrame
//
//  Created by Michael Kavouras on 12/7/15.
//  Copyright © 2015 Michael Kavouras. All rights reserved.
//

import Foundation
import Alamofire

enum ParticleEndpoint {
    case DeviceInfo(Device)
    case CallFunction(Device, String)
    
    func URL() -> NSURL {
        switch self {
        case .DeviceInfo(let device):
            return NSURL(string: "\(devicesURL())\(device.deviceID)")!
        case .CallFunction(let device, let function):
            return NSURL(string: "\(devicesURL())/devices\(device.deviceID)/\(function)")!
        }
    }
    
    func devicesURL() -> NSString {
        return "\(APIBase())/\(APIVersion())/devices"
    }
    
    func APIBase() -> NSString {
        return "https://api.particle.io"
    }
    
    func APIVersion() -> NSString {
        return "v1"
    }
}

class ParticleAPIManager {
    
    private class var accessToken: String {
        return "a946e1b8198e4304ce32abed2e6e96de553d2081"
    }
    
    class func fetchDeviceInfo(device: Device, completion: (info: [String: AnyObject]) -> Void) {
        let url = ParticleEndpoint.DeviceInfo(device).URL()
        Alamofire.request(.GET, url, parameters: defaultParams(), encoding: .URL, headers: nil).responseJSON { (response: Response<AnyObject, NSError>) -> Void in
            
            if response.result.isSuccess {
                print(response.result.value)
                if let value = response.result.value as? [String: AnyObject] {
                    completion(info: value)
                }
            }
        }
    }
    
    class func callFunc(name: String, forDevice device: Device, withArgs args: String) {
        
        let url = ParticleEndpoint.CallFunction(device, name).URL()
        var params = defaultParams()
        params["args"] = args
        
        Alamofire.request(.POST, url, parameters: params, encoding: .URL, headers: nil).responseJSON { (response: Response<AnyObject, NSError>) -> Void in
        }
    }
    
    class func defaultParams() -> [String: String] {
        return ["access_token" : accessToken]
    }
}