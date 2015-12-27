//
//  ParticleDeviceSettingsTableViewCell.swift
//  GlowFrame
//
//  Created by Michael Kavouras on 12/26/15.
//  Copyright © 2015 Michael Kavouras. All rights reserved.
//

import UIKit

class ParticleDeviceTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var connectedImageView: UIImageView!
    
    class var CellIdentifier: String {
        return TableCell.ParticleDevice.Identifier
    }
    
}
