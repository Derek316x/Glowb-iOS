//
//  ParticleDeviceRepresentation.swift
//  GlowFrame
//
//  Created by Michael Kavouras on 12/24/15.
//  Copyright © 2015 Michael Kavouras. All rights reserved.
//

import Foundation
import Alamofire

typealias VariableType = String

struct ParticleDevice {
    let name: String
    let ID: String
    let productID: Int
    let connected: Bool
    let lastIPAddress: String?
    let functions: [String]?
    let variables: [String : VariableType]?
    
    var type: String {
        return [0:"Core", 6: "Photon"][productID]!
    }
    
    init?(info: [String: AnyObject]) {
        guard let name = info["name"] as? String,
            id = info["id"] as? String,
            productID = info["product_id"] as? Int,
            connected = info["connected"] as? Bool else {
                return nil
            }
    
        self.productID = productID
        self.name = name
        self.ID = id
        self.connected = connected
        self.lastIPAddress = info["last_ip_address"] as? String
        self.variables = info["variables"] as? [String : VariableType]
        self.functions = info["functions"] as? [String]
    }
    
    
    static func fetch(deviceID: String, completion: (ParticleDevice?) -> Void) -> Request? {
        return ParticleAPIManager.fetchDeviceInfo(deviceID, completion: { (info) -> Void in
            completion(ParticleDevice(info: info))
        })
    }
    
}