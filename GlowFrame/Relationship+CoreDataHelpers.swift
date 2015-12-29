//
//  Relationship+CoreDataMethods.swift
//  GlowFrame
//
//  Created by Michael Kavouras on 12/29/15.
//  Copyright © 2015 Michael Kavouras. All rights reserved.
//

import UIKit
import CoreData

extension Relationship {
    
    class var EntityName: String {
        return "Relationship"
    }
    
    class func create(image: UIImage, device: Device, name: String) -> Relationship?
    {
        
        guard let delegate = UIApplication.sharedApplication().delegate as? AppDelegate,
            context = delegate.managedObjectContext,
            relationship = NSEntityDescription.insertNewObjectForEntityForName(Relationship.EntityName, inManagedObjectContext: context) as? Relationship else
        {
            return nil
        }
        
        relationship.image = image
        relationship.device = device
        relationship.name = name
        relationship.createdAt = NSDate()
        
        return relationship
    }
    
    class func delete(relationship: Relationship, completion: ((Bool) -> Void)?)
    {
        guard let delegate = UIApplication.sharedApplication().delegate as? AppDelegate,
            context = delegate.managedObjectContext else {
                return
        }
        
        context.deleteObject(relationship)
        do {
            try context.save()
            completion?(true)
        } catch {
            completion?(false)
        }
    }
}