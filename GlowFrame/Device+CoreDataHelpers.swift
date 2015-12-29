//
//  Device+CoreDataHelpers.swift
//  GlowFrame
//
//  Created by Michael Kavouras on 12/29/15.
//  Copyright © 2015 Michael Kavouras. All rights reserved.
//

import UIKit
import CoreData
import Spark_SDK

extension Device {
    
    class var EntityName: String {
        return "Device"
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
    
    func save() throws
    {
        guard let delegate = UIApplication.sharedApplication().delegate as? AppDelegate,
            context = delegate.managedObjectContext else {
            return
        }
        
        try context.save()
    }
}