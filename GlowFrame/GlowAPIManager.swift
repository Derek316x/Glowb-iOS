//
//  GlowAPIManager.swift
//  GlowFrame
//
//  Created by Michael Kavouras on 12/12/15.
//  Copyright © 2015 Michael Kavouras. All rights reserved.
//

import Foundation

class GlowAPIManager {
    class func glowForRelationship(relationship: Relationship) {
        ParticleAPIManager.callFunc("glow", forDeviceID: relationship.device.deviceID, withArgs: "purple")
    }
}