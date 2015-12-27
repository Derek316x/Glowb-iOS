//
//  TableCellIdentifiers.swift
//  GlowFrame
//
//  Created by Michael Kavouras on 12/26/15.
//  Copyright © 2015 Michael Kavouras. All rights reserved.
//

import UIKit

protocol Themeable {
    var theme: TableCellTheme {
        get
    }
    
    func setLightTheme()
    func setDarkTheme()
}

enum TableCellTheme {
    case Light
    case Dark
}

enum TableCell  {
    case Basic
    case LabelTextField
    case ParticleDevice
    
    var Identifier: String {
        switch self {
        case .Basic: return "BasicCellIdentifier"
        case .LabelTextField: return "LabelTextFieldCellIdentifier"
        case .ParticleDevice: return "ParticleDeviceCellIdentifier"
        }
    }
    
    private var NibName: String {
        switch self {
        case .Basic: return "BasicTableViewCell"
        case .LabelTextField: return "LabelTextFieldTableViewCell"
        case .ParticleDevice: return "ParticleDeviceTableViewCell"
        }
    }
    
    var Nib: UINib {
        return UINib(nibName: NibName, bundle: nil)
    }
    
    func dequeue(tableView: UITableView, forIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCellWithIdentifier(Identifier, forIndexPath: indexPath)
    }
}
