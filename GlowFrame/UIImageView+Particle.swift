//
//  UIImageView+Particle.swift
//  GlowFrame
//
//  Created by Michael Kavouras on 12/26/15.
//  Copyright © 2015 Michael Kavouras. All rights reserved.
//

import UIKit

extension UIImage {
    class func imageForConnectionState(connected: Bool) -> UIImage
    {
        if (connected) {
            return UIImage(named: "connected")!
        } else {
            return UIImage(named: "disconnected")!
        }
    }
}