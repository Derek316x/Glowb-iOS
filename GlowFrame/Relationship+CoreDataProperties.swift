//
//  Relationship+CoreDataProperties.swift
//  GlowFrame
//
//  Created by Michael Kavouras on 12/28/15.
//  Copyright © 2015 Michael Kavouras. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Relationship {

    @NSManaged var image: NSObject?
    @NSManaged var name: String?
    @NSManaged var device: Device?

}
