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
    
    init(device: SparkDevice, color: String)
    {
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = delegate.managedObjectContext
        let entity = NSEntityDescription.entityForName(Device.EntityName, inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        particleDevice = device
        self.color = color
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
