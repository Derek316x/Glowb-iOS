//
//  DeviceManagementView.swift
//  GlowFrame
//
//  Created by Michael Kavouras on 12/19/15.
//  Copyright © 2015 Michael Kavouras. All rights reserved.
//

import UIKit

class DeviceManagementView: UIView {
    
    var device: Device?
    
    private var loadDeviceInfoTask: NSURLSessionDataTask?
    
    func loadDeviceInfo() {
        guard let device = device else { return }
        
        device.loadInfo { (info) -> Void in
            print("DID IT ALL THE WAY")
        }
    }

    class func viewFromNib() -> DeviceManagementView? {
        guard let view = NSBundle.mainBundle().loadNibNamed(self.nibName(), owner: self, options: nil)[0] as? DeviceManagementView else {
            return nil
        }
        
        return view
    }

    class func nibName() -> String {
        return "DeviceManagementView"
    }
}
