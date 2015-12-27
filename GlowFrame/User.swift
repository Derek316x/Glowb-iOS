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
    let particleAccount = SparkCloud.sharedInstance(    )
    var isLoggedInToParticle: Bool {
        return particleAccount.isLoggedIn
    }
    var loggedInParticleUsername: String! {
        return particleAccount.loggedInUsername
    }
    
    var relationships = [Relationship]()
    var devices = Set<SparkDevice>()
    
    func getDevice(deviceID: String, force: Bool = false, completion: ((SparkDevice?, NSError?) -> Void)?) -> NSURLSessionDataTask?
    {
        if !force {
            // Short circuit if we already have the device
            let equal = devices.filter { $0.id == deviceID }
            guard equal.count == 0 else {
                completion?(equal.first, nil)
                return nil
            }
        }
        
        return particleAccount.getDevice(deviceID) { (device: SparkDevice?, error: NSError?) -> Void in
            if !force {
                if let device = device {
                    let equal = self.devices.filter { $0.id == deviceID }
                    if equal.count == 0 {
                        self.devices.insert(device)
                    }
                }
            }
            
            completion?(device, error)
        }
    }
    
    func getDevices(completion: (([SparkDevice]?, NSError?) -> Void)?) -> NSURLSessionDataTask? {
        return particleAccount.getDevices({ (devices: [SparkDevice]?, error: NSError?) -> Void in
            if let devices = devices {
                self.devices = Set(devices)
            }
            completion?(devices, error)
        })
    }
    
}