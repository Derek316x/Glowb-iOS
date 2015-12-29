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
        guard let controller = fetchedResultsController else {
            return [Relationship]()
        }
        
        if let objects = controller.fetchedObjects as? [Relationship] {
            return objects
        }
        
        return [Relationship]()
    }
    
    var devices = Set<SparkDevice>()
    
    override init()
    {
        super.init()
        
        guard let controller = fetchedResultsController else {
            return
        }
        
        do {
            try controller.performFetch()
        } catch _ {}
        
        setup()
    }
    
    private func setup()
    {
        loadSavedRelationships()
    }
    
    private func loadSavedRelationships()
    {
        
    }
    
    func getDevice(deviceID: String, force: Bool = false, completion: ((SparkDevice?, NSError?) -> Void)?) -> NSURLSessionDataTask?
    {
        if !force {
            // Short circuit if we already have the device
            let equal = devices.filter { $0.id == deviceID }
            guard equal.count == 0 else {
                completion?(equal.first, nil)
                return nil
            }
        }
        
        return particleAccount.getDevice(deviceID) { (device: SparkDevice?, error: NSError?) -> Void in
            if !force {
                if let device = device {
                    let equal = self.devices.filter { $0.id == deviceID }
                    if equal.count == 0 {
                        self.devices.insert(device)
                    }
                }
            }
            
            completion?(device, error)
        }
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
    
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?)
    {
       // Not sure, but implementing this method updates `fetchedObjects`
    }
    
}