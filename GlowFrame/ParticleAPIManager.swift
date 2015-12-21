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
    
    private class var accessToken: String {
        return "a946e1b8198e4304ce32abed2e6e96de553d2081"
    }
    
    class func fetchDeviceInfo(device: Device, completion: (info: [String: AnyObject]) -> Void) -> Request {
        
        let url = ParticleEndpoints.DeviceInfo(device).URL()
        
        return Alamofire.request(.GET, url, parameters: defaultParams, encoding: .URL, headers: nil).responseJSON { (response: Response<AnyObject, NSError>) -> Void in
            
            if response.result.isSuccess {
                if let value = response.result.value as? [String: AnyObject] {
                    completion(info: value)
                }
            }
        }
    }
    
    class func callFunction(name: String, forDevice device: Device, withArgs args: String, completion: (success: Bool) -> Void) -> Request {
        
        let url = ParticleEndpoints.CallFunction(device, name).URL()
        
        var params = defaultParams
        params["args"] = args
        
        return Alamofire.request(.POST, url, parameters: params, encoding: .URL, headers: nil).responseJSON { (response: Response<AnyObject, NSError>) -> Void in
            print(response.result.value)
        }
    }
}

enum ParticleEndpoints {
    
    case DeviceInfo(Device)
    case CallFunction(Device, String)
    
    func URL() -> NSURL {
        switch self {
        case .DeviceInfo(let device):
            return NSURL(string: "\(devicesURL())/\(device.ID)")!
        case .CallFunction(let device, let function):
            return NSURL(string: "\(devicesURL())/\(device.ID)/\(function)")!
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