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
    
    func activate()
    {
        device.particleDevice.callFunction("glow", withArguments: [device.color], completion: nil)
    }
    
}
