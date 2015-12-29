//
//  User.swift
//  GlowFrame
//
//  Created by Michael Kavouras on 12/24/15.
//  Copyright © 2015 Michael Kavouras. All rights reserved.
//

import Foundation
import Spark_SDK
import CoreData

class User: NSObject, NSFetchedResultsControllerDelegate {
    
    static let currentUser = User()
    
    let particleAccount = SparkCloud.sharedInstance()
    
    var isLoggedInToParticle: Bool {
        return particleAccount.isLoggedIn
    }
    
    var loggedInParticleUsername: String! {
        return particleAccount.loggedInUsername
    }
    
    lazy var fetchedResultsController: NSFetchedResultsController? = {
        guard let delegate = UIApplication.sharedApplication().delegate as? AppDelegate,
            context = delegate.managedObjectContext else {
                return nil
        }
        
        let request = NSFetchRequest(entityName: Relationship.EntityName)
        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)];
        let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = self
        
        return controller
    }()
    
    var relationships: [Relationship] {
        guard let controller = fetchedResultsController,
            objects = controller.fetchedObjects as? [Relationship] else {
            return [Relationship]()
        }
        
        return objects
    }
    
    var devices = Set<SparkDevice>()
    
    override init()
    {
        super.init()
        
        guard let controller = fetchedResultsController else { return }
        do {
            try controller.performFetch()
            let devices = relationships.map { $0.device }
            for device in devices {
                self.devices.insert(device.particleDevice)
                device.refresh()
            }
        } catch _ {}
    }
    
    func getDevices(completion: (([SparkDevice]?, NSError?) -> Void)?) -> NSURLSessionDataTask?
    {
        return particleAccount.getDevices({ (devices: [SparkDevice]?, error: NSError?) -> Void in
            if let devices = devices {
                self.devices = Set(devices)
            }
            completion?(devices, error)
        })
    }
    
    
    // Fetched results controller delegate
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?)
    {
       // Not sure why, but implementing this method updates `fetchedObjects`
    }
    
}