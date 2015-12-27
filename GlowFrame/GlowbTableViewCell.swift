//
//  GlowbTableViewCell.swift
//  GlowFrame
//
//  Created by Michael Kavouras on 12/26/15.
//  Copyright © 2015 Michael Kavouras. All rights reserved.
//

import UIKit

class GlowbTableViewCell: UITableViewCell, Themeable {
    
    var theme: TableCellTheme = .Light {
        didSet {
            switch theme {
            case .Light: setLightTheme()
            case .Dark: setDarkTheme()
            }
        }
    }
    
    func setLightTheme() {
        // abstract
    }
    
    func setDarkTheme() {
        backgroundColor = UIColor.blackColor()
        // abstract
    }
    
}
