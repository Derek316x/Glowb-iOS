//
//  DeviceManagementView.swift
//  GlowFrame
//
//  Created by Michael Kavouras on 12/19/15.
//  Copyright © 2015 Michael Kavouras. All rights reserved.
//

import UIKit
import Alamofire

extension UIImage {
    class func imageForConnectionState(connected: Bool) -> UIImage {
        if (connected) {
            return UIImage(named: "connected")!
        } else {
            return UIImage(named: "disconnected")!
        }
    }
}

class DeviceManagementView: UIView {
    
    @IBOutlet weak var deviceNameLabel: UILabel!
    @IBOutlet weak var deviceStatusImageView: UIImageView!
    
    var device: Device? {
        didSet {
            deviceNameLabel.text = device!.name
            if let connection = device!.connected {
                deviceStatusImageView.image = UIImage.imageForConnectionState(connection)
            }
        }
    }
    
    private var loadDeviceInfoTask: Request?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func loadDeviceInfo() {
        loadDeviceInfoTask = device?.updateInfo({ (device: Device) -> Void in
            self.device = device
        })
    }

    @IBAction func refreshButtonTapped(sender: AnyObject) {
        loadDeviceInfo()
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
