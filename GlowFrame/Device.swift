//
//  Device.swift
//  GlowFrame
//
//  Created by Michael Kavouras on 12/7/15.
//  Copyright © 2015 Michael Kavouras. All rights reserved.
//

import Foundation
import Alamofire
import Spark_SDK

class Device {
    
    let deviceID: String
    var particleDevice:  SparkDevice?
    var deviceSettings: DeviceSettings?
    var type: String? {
        guard let device = particleDevice else {
            return nil
        }
        return [0: "Core", 6: "Photon"][device.type.rawValue]
    }
    private var updatedAt: NSDate?
    
    var connected: Bool {
        guard let pr = particleDevice else { return false }
        return pr.connected
    }
    
    init(deviceID: String)
    {
        self.deviceID = deviceID
        particleDevice = nil
        updatedAt = nil
    }

    func updateInfo(force: Bool = false, completion: () -> Void) -> NSURLSessionTask?
    {
        // Don't reload unless it's been at least 2 minutes. Arbitrary.
        if !force {
            if let updatedAt = updatedAt {
                guard NSDate().timeIntervalSinceDate(updatedAt) > 60 * 2 else {
                    return nil
                }
            }
        }
        
        return updateParticleRepresentation(force, completion)
    }
    
    private func updateParticleRepresentation(force: Bool = false, _ completion: () -> Void) -> NSURLSessionTask?
    {
        return User.currentUser.getDevice(deviceID, force: force, completion: { (device: SparkDevice!, error: NSError!) -> Void in
            if error == nil {
                self.updatedAt = NSDate()
                self.particleDevice = device
            }
            completion()
        })
    }
}
