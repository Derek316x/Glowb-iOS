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
    
    class func fetchAllObjects() -> [Relationship]?
    {
        guard let delegate = UIApplication.sharedApplication().delegate as? AppDelegate,
            context = delegate.managedObjectContext else {
                return nil
        }
        
        let request = NSFetchRequest(entityName: Relationship.EntityName)
        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)];
        let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try controller.performFetch()
            return controller.fetchedObjects as? [Relationship]
        } catch _ {
            return nil
        }
    }
    
    func activate()
    {
        device.particleDevice.callFunction("glow", withArguments: [device.color], completion: nil)
    }
    
    class func deleteEntity(relationship: Relationship, completion: () -> Void)
    {
        guard let delegate = UIApplication.sharedApplication().delegate as? AppDelegate,
            context = delegate.managedObjectContext else {
                return
        }
        
        context.deleteObject(relationship)
        do {
            try context.save()
            completion()
        } catch {}
    }
    
}