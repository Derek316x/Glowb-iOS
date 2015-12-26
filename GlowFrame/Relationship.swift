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
    
    init(image: UIImage, device: Device)
    {
        self.image = image
        self.device = device
    }
    
    func activate() {
        device.particleDevice?.callFunction("glow", withArguments: ["purple"], completion: nil)
    }
    
}