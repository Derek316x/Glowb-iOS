//
//  DeviceManagementView.swift
//  GlowFrame
//
//  Created by Michael Kavouras on 12/19/15.
//  Copyright © 2015 Michael Kavouras. All rights reserved.
//

import UIKit
import Alamofire


class DeviceManagementView: UIView {
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var deviceInformationView: UIView!
    @IBOutlet weak var deviceNameLabel: UILabel!
    @IBOutlet weak var deviceStatusImageView: UIImageView!
    @IBOutlet weak var deviceProductTypeLabel: UILabel!
    
    func displayDevice(device: Device)
    {
        showLoadedDevice(device)
    }
    
    
    // MARK: - Imperative
    
    private func showLoadedDevice(device: Device)
    {
        deviceNameLabel.text = device.particleDevice.name
        if let type = device.type {
            deviceProductTypeLabel.text = type
        }
        deviceStatusImageView.image = UIImage.imageForConnectionState(device.particleDevice.connected)
        
        loadingIndicator.stopAnimating()
        deviceInformationView.hidden = false
    }
    
    private func showLoadingDevice()
    {
        deviceNameLabel.text = ""
        deviceProductTypeLabel.text = ""
        deviceStatusImageView.image = nil
        
        loadingIndicator.startAnimating()
        deviceInformationView.hidden = true
    }
    
    // MARK: - Declarative
    
    class func viewFromNib() -> DeviceManagementView?
    {
        guard let view = NSBundle.mainBundle().loadNibNamed(self.nibName(), owner: self, options: nil)[0] as? DeviceManagementView else {
            return nil
        }
        return view
    }

    class func nibName() -> String
    {
        return "DeviceManagementView"
    }
}
