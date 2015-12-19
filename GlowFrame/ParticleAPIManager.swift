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
    
    private class var accessToken: String {
        return "a946e1b8198e4304ce32abed2e6e96de553d2081"
    }
    
    class func callFunc(name: String, forDeviceID deviceID: String, withArgs args: String) {
        
        let url = NSURL(string: "https://api.particle.io/v1/devices/\(deviceID)/glow")
        let params = ["access_token" : accessToken, "args" : args]
        
        Alamofire.request(.POST, url!, parameters: params, encoding: .URL, headers: nil).responseJSON { (response: Response<AnyObject, NSError>) -> Void in
        }
    }
}