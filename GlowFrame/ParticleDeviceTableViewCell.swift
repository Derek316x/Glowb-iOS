//
//  ParticleDeviceSettingsTableViewCell.swift
//  GlowFrame
//
//  Created by Michael Kavouras on 12/26/15.
//  Copyright © 2015 Michael Kavouras. All rights reserved.
//

import UIKit
import Spark_SDK

class ParticleDeviceTableViewCell: GlowbTableViewCell {
    
    var enabled: Bool = true
    
    var device: SparkDevice? {
        didSet {
            nameLabel.text = device!.name
            connectedImageView.image = UIImage.imageForConnectionState(device!.connected)
            
            if !device!.connected {
                setDisabled()
            } else {
                setEnabled()
            }
        }
    }

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet private weak var connectedImageView: UIImageView!
    
    class var CellIdentifier: String {
        return TableCell.ParticleDevice.Identifier
    }
    
    override func setDarkTheme()
    {
        nameLabel.textColor = UIColor.whiteColor()
        backgroundColor = UIColor.blackColor()
        super.setDarkTheme()
    }
    
    private func setDisabled()
    {
        selectionStyle = .None
        nameLabel.textColor = UIColor.grayColor()
        enabled = false
    }
    
    private func setEnabled()
    {
        selectionStyle = .Default
        nameLabel.textColor = theme == .Dark ? UIColor.whiteColor() : UIColor.blackColor()
        enabled = true
    }
}
