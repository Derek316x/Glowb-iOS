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
    let type: String?
    
    init?(info: [String: AnyObject]) {
        guard let id = info["id"] as? String else { return nil }
        
        ID = id
        functions = info["functions"] as? [String]
        variables = info["variable"] as? [String]
        name = info["name"] as? String
        updatedAt = NSDate()
        connected = info["connected"] as? Bool
        
        var t: String? = nil
        if let productID = info["product_id"] as? Int {
            t = productID == 0 ? "Core" : "Photon"
        }
        type = t
    }
    
    init(deviceID: String) {
        ID = deviceID
        functions = nil
        variables = nil
        name = nil
        updatedAt = nil
        connected = nil
        type = nil
    }

    func updateInfo(force: Bool = false, completion: (Device) -> Void) -> Request? {
        
        // 2 minute threshold
        if force == false {
            if let updatedAt = updatedAt {
                guard NSDate().timeIntervalSinceDate(updatedAt) > 60 * 2 else { return nil }
            }
        }
        
        return ParticleAPIManager.fetchDeviceInfo(self) { (info: [String : AnyObject]) -> Void in
            if let updated = Device(info: info) {
                completion(updated)
            }
        }
    }
}
