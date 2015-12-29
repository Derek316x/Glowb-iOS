//
//  Relationship.swift
//  GlowFrame
//
//  Created by Michael Kavouras on 12/6/15.
//  Copyright © 2015 Michael Kavouras. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class Relationship: NSManagedObject {
    
    class var EntityName: String {
        return "Relationship"
    }
    
    init(image: UIImage, device: Device, name: String)
    {
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = delegate.managedObjectContext
        let entity = NSEntityDescription.entityForName(Relationship.EntityName, inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        self.image = image
        self.device = device
        self.name = name
    }
    
    func activate()
    {
        device.particleDevice.callFunction("glow", withArguments: [device.color], completion: nil)
    }
    
}