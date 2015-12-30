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
    
    func refresh()
    {
        particleDevice.refresh { (error: NSError?) -> Void in
            guard error == nil else { return }
            do {
                try self.save()
            } catch {
                print("There was a problem saving this device: \(self.particleDevice.name)")
            }
        }
    }
    
}
