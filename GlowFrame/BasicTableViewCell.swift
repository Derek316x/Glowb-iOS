//
//  BasicTableViewCell.swift
//  GlowFrame
//
//  Created by Michael Kavouras on 12/26/15.
//  Copyright © 2015 Michael Kavouras. All rights reserved.
//

import UIKit

class BasicTableViewCell: GlowbTableViewCell {

    class var CellIdentifier: String {
        return TableCell.Basic.Identifier
    }
    
    override func setDarkTheme() {
        textLabel?.textColor = UIColor.whiteColor()
        super.setDarkTheme()
    }
}
