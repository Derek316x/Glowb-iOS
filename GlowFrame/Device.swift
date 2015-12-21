//
//  Device.swift
//  GlowFrame
//
//  Created by Michael Kavouras on 12/7/15.
//  Copyright © 2015 Michael Kavouras. All rights reserved.
//

import Foundation
import Alamofire

struct Device {
    
    let functions: [String]?
    let variables: [String]?
    let ID: String
    let name: String?
    let updatedAt: NSDate?
    let connected: Bool?
    
    init?(info: [String: AnyObject]) {
        guard let id = info["id"] as? String else { return nil }
        
        ID = id
        functions = info["functions"] as? [String]
        variables = info["variable"] as? [String]
        name = info["name"] as? String
        updatedAt = NSDate()
        connected = info["connected"] as? Bool
    }
    
    init(deviceID: String) {
        ID = deviceID
        functions = nil
        variables = nil
        name = nil
        updatedAt = nil
        connected = nil
    }

    func updateInfo(completion: (Device) -> Void) -> Request? {
        
        // 2 minute threshold
        if let updatedAt = updatedAt {
            guard NSDate().timeIntervalSinceDate(updatedAt) > 60 * 2 else { return nil }
        }
        
        return ParticleAPIManager.fetchDeviceInfo(self) { (info: [String : AnyObject]) -> Void in
            if let updated = Device(info: info) {
                completion(updated)
            }
        }
    }
}
