//
//  ParticleSettingsTableViewController.swift
//  GlowFrame
//
//  Created by Michael Kavouras on 12/24/15.
//  Copyright © 2015 Michael Kavouras. All rights reserved.
//

import UIKit

class ParticleSettingsTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    private func setup() {
        if User.currentUser.isLoggedInToParticle {
            navigationItem.title = User.currentUser.loggedInParticleUsername
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if !User.currentUser.isLoggedInToParticle {
            return 2
        }
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !User.currentUser.isLoggedInToParticle {
            switch section {
            case 0:
                return 2
            case 1:
                return 1
            default:
                return 0
            }
        } else {
            return 1
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if !User.currentUser.isLoggedInToParticle {
            
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
            
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("BasicCellIdentifier", forIndexPath: indexPath)
            cell.textLabel?.text = "Log Out"
            return cell
        }
    }
    
    // MARK: - Table view delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if User.currentUser.isLoggedInToParticle {
            if (indexPath.section == 0 && indexPath.row == 0) {
                User.currentUser.particleAccount.logout()
            }
        } else {
            if indexPath.section == 1 && indexPath.row == 0 {
                loginParticleUser()
            }
        }
    }
    
    private func loginParticleUser() {
        let emailIP = NSIndexPath(forRow: 0, inSection: 0)
        let passwordIP = NSIndexPath(forRow: 1, inSection: 0)
        
        guard let emailCell = tableView.cellForRowAtIndexPath(emailIP) as? LabelFieldTableViewCell,
            passwordCell = tableView.cellForRowAtIndexPath(passwordIP) as? LabelFieldTableViewCell else {
                    return
                }
        
        User.currentUser.particleAccount.loginWithUser(emailCell.textField.text, password: passwordCell.textField.text, completion: { (error: NSError!) -> Void in
            if error != nil {
                print(error.userInfo)
            }
        })
    }
}
