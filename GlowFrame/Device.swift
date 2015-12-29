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
    
}


// Core Data

extension Device {
    
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
    
}
