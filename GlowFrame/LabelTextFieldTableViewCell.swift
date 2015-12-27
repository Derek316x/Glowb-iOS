//
//  LabelFieldTableViewCell.swift
//  GlowFrame
//
//  Created by Michael Kavouras on 12/24/15.
//  Copyright © 2015 Michael Kavouras. All rights reserved.
//

import UIKit

class LabelTextFieldTableViewCell: GlowbTableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    class var CellIdentifier: String {
        return TableCell.LabelTextField.Identifier
    }
    
    override func setDarkTheme() {
        label.textColor = UIColor.whiteColor()
        textField.textColor = UIColor.whiteColor()
        textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder!, attributes: [NSForegroundColorAttributeName: UIColor.lightGrayColor()])

        super.setDarkTheme()
    }
}
