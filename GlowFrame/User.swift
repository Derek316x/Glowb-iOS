//
//  User.swift
//  GlowFrame
//
//  Created by Michael Kavouras on 12/24/15.
//  Copyright © 2015 Michael Kavouras. All rights reserved.
//

import Foundation
import Spark_SDK

class User {
    
    static let currentUser = User()
    let particleAccount = SparkCloud.sharedInstance()
    var isLoggedInToParticle: Bool {
        return particleAccount.isLoggedIn
    }
    var loggedInParticleUsername: String! {
        return particleAccount.loggedInUsername
    }
    
    var relationships: [Relationship] = {
        return [
            Relationship(image: UIImage(named: "meagan")!, device: Device(deviceID: "53ff6d066667574818431267"), nickname: "Meagan"),
            Relationship(image: UIImage(named: "hannah")!, device: Device(deviceID: "300035000547343232363230"), nickname: "Hannah"),
            Relationship(image: UIImage(named: "boys")!, device: Device(deviceID: "300035000547343232363230"), nickname: "Andrew + Sam")
        ]
    }()
    
    var devices = Set<SparkDevice>()
    
    func getDevice(deviceID: String, force: Bool = false, completion: (aDevice: SparkDevice!, aError: NSError!) -> Void) -> NSURLSessionDataTask?
    {
        if !force {
            // Short circuit if we already have the device
            let equal = devices.filter { $0.id == deviceID }
            guard equal.count == 0 else {
                completion(aDevice: equal.first!, aError: nil)
                return nil
            }
        }
        
        return particleAccount.getDevice(deviceID) { (device: SparkDevice!, error: NSError!) -> Void in
            if !force && device != nil {
                let equal = self.devices.filter { $0.id == deviceID }
                if equal.count == 0 {
                    self.devices.insert(device)
                }
            }
            completion(aDevice: device, aError: error)
        }
    }
    
    func getDevices(completion: (([SparkDevice]!, NSError!) -> Void)?) -> NSURLSessionDataTask {
        return particleAccount.getDevices({ (response: [AnyObject]!, error: NSError!) -> Void in
            guard let devices = response as? [SparkDevice] else {
                completion?(nil, error)
                return
            }
            self.devices = Set(devices)
            completion?(devices, error)
        })
    }
    
}