//
//  ParticleLoggedOutTableViewDataSource.swift
//  GlowFrame
//
//  Created by Michael Kavouras on 12/24/15.
//  Copyright © 2015 Michael Kavouras. All rights reserved.
//

import Foundation
import UIKit

class ParticleLoggedOutTableViewDataSource: NSObject, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 2
        case 1: return 1
        default: return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
                guard let cell = tableView.dequeueReusableCellWithIdentifier(LabelFieldTableViewCell.CellIdentifier, forIndexPath: indexPath) as? LabelFieldTableViewCell else {
                    return UITableViewCell()
                }
                
                switch indexPath.row {
                case 0:
                    cell.label.text = "Email Address"
                    cell.textField.keyboardType = .EmailAddress
                    return cell
                case 1:
                    cell.label.text = "Password"
                    cell.textField.secureTextEntry = true
                    return cell
                default:
                    return cell
                }
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("BasicCellIdentifier", forIndexPath: indexPath)
            cell.textLabel?.text = "Log In"
            return cell
        default:
            return UITableViewCell()
        }
    }
}