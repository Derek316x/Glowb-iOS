//
//  Device.swift
//  GlowFrame
//
//  Created by Michael Kavouras on 12/7/15.
//  Copyright © 2015 Michael Kavouras. All rights reserved.
//

import Foundation
import Alamofire

class Device {
    
    let deviceID: String
    var particleRepresentation: ParticleDevice?
    var deviceSettings: DeviceSettings?
    private var updatedAt: NSDate?
    var connected: Bool {
        guard let pr = particleRepresentation else { return false }
        return pr.connected
    }
    
    
    init(deviceID: String) {
        self.deviceID = deviceID
        particleRepresentation = nil
        updatedAt = nil
    }

    func updateInfo(force: Bool = false, completion: () -> Void) -> Request? {
        
        // don't reload unless it's been at least 2 minutes. arbitrary
        if !force {
            if let updatedAt = updatedAt {
                guard NSDate().timeIntervalSinceDate(updatedAt) > 60 * 2 else {
                    return nil
                }
            }
        }
        
        return updateParticleRepresentation(completion)
    }
    
    private func updateParticleRepresentation(completion: () -> Void) -> Request? {
        
        return ParticleDevice.fetch(deviceID, completion: { (particleDevice: ParticleDevice?) -> Void in
            self.updatedAt = NSDate()
            self.particleRepresentation = particleDevice
            completion()
        })
    }
}
