//
//  Relationship.swift
//  GlowFrame
//
//  Created by Michael Kavouras on 12/6/15.
//  Copyright © 2015 Michael Kavouras. All rights reserved.
//

import Foundation
import UIKit

class Relationship {
    
    let image: UIImage
    let device: Device
    let name: String
    
    init(image: UIImage, device: Device, name: String)
    {
        self.image = image
        self.device = device
        self.name = name
    }
    
    func activate() {
        device.particleDevice.callFunction("glow", withArguments: [device.settings.color], completion: nil)
    }
    
}