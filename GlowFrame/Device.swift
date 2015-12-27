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
    
    private var updatedAt: NSDate?
    var particleDevice:  SparkDevice
    var settings: DeviceSettings
    var type: String? {
        return [0: "Core", 6: "Photon"][particleDevice.type.rawValue]
    }
    var connected: Bool {
        return particleDevice.connected
    }
    
    init(device: SparkDevice, settings: DeviceSettings)
    {
        particleDevice = device
        self.settings = settings
    }

    func updateInfo(force: Bool = false, completion: (() -> Void)?) -> NSURLSessionTask?
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
    
    private func updateParticleRepresentation(force: Bool = false, _ completion: (() -> Void)?) -> NSURLSessionTask?
    {
        return User.currentUser.getDevice(particleDevice.id, force: force, completion: { (device: SparkDevice?, error: NSError?) -> Void in
            if let device = device {
                self.updatedAt = NSDate()
                self.particleDevice = device
            }
            completion?()
        })
    }
    
}
