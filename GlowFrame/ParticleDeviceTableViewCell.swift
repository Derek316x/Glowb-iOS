//
//  ParticleDeviceSettingsTableViewCell.swift
//  GlowFrame
//
//  Created by Michael Kavouras on 12/26/15.
//  Copyright © 2015 Michael Kavouras. All rights reserved.
//

import UIKit
import Spark_SDK

class ParticleDeviceTableViewCell: UITableViewCell {
    
    var device: SparkDevice? {
        didSet {
            nameLabel.text = device!.name
            connectedImageView.image = UIImage.imageForConnectionState(device!.connected)
        }
    }

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var connectedImageView: UIImageView!
    
    class var CellIdentifier: String {
        return TableCell.ParticleDevice.Identifier
    }
    
}
