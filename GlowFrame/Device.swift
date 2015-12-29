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
    
    var type: String? {
        return [0: "Core", 6: "Photon"][particleDevice.type.rawValue]
    }
    
    var connected: Bool {
        return particleDevice.connected
    }
    
    
    /* something like this */
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        refresh()
    }
    
    func refresh()
    {
        User.currentUser.particleAccount.getDevice(particleDevice.id) { (device: SparkDevice?, error: NSError?) -> Void in
            if let device = device {
                self.particleDevice = device
                do {
                    try self.save()
                } catch _ {}
            }
        }
    }
    
}
