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
import CoreData

class Device: NSManagedObject {
    
    class var EntityName: String {
        return "Device"
    }
    
    var type: String? {
        return [0: "Core", 6: "Photon"][particleDevice.type.rawValue]
    }
    
    var connected: Bool {
        return particleDevice.connected
    }
    
    class func create(particle: SparkDevice, color: String) -> Device?
    {
        guard let delegate = UIApplication.sharedApplication().delegate as? AppDelegate,
            context = delegate.managedObjectContext,
            device = NSEntityDescription.insertNewObjectForEntityForName(Device.EntityName, inManagedObjectContext: context) as? Device else
        {
            return nil
        }
        
        device.particleDevice = particle
        device.color = color
        
        return device
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
