//
//  ParticleSettingsTableViewController.swift
//  GlowFrame
//
//  Created by Michael Kavouras on 12/24/15.
//  Copyright © 2015 Michael Kavouras. All rights reserved.
//

import UIKit
import Spark_SDK

class ParticleSettingsTableViewController: UITableViewController {
    
    var presentedModally: Bool = false
    var devices = User.currentUser.devices.sort { $0.name < $1.name }
    
    class var StoryboardIdentifier: String {
        return "ParticleSettingsIdentifier"
    }
    
    override func viewDidLoad()
    {
        setup()
        
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
        
        if let ip = tableView.indexPathForSelectedRow {
            tableView.deselectRowAtIndexPath(ip, animated: true)
        }
        
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }
    
    private func setup()
    {
        if User.currentUser.isLoggedInToParticle {
            navigationItem.title = User.currentUser.loggedInParticleUsername
        } else {
            navigationItem.title = "Particle"
        }
        
        setupTableView()
    }
    
    private func setupTableView()
    {
        tableView.registerNib(TableCell.Basic.Nib, forCellReuseIdentifier: TableCell.Basic.Identifier)
        tableView.registerNib(TableCell.LabelTextField.Nib, forCellReuseIdentifier: TableCell.LabelTextField.Identifier)
        tableView.registerNib(TableCell.ParticleDevice.Nib, forCellReuseIdentifier: TableCell.ParticleDevice.Identifier)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        if User.currentUser.isLoggedInToParticle {
            return 2
        } else {
            return 2
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if User.currentUser.isLoggedInToParticle {
            switch section {
            case 0: return devices.count
            case 1: return 1
            default: return 0
            }
        } else {
            switch section {
            case 0: return 2
            case 1: return 1
            default: return 0
            }
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        // Logged In
        if User.currentUser.isLoggedInToParticle {
            switch indexPath.section {
                
            case 0: // Devices
                
                guard let cell = TableCell.ParticleDevice.dequeue(tableView, forIndexPath: indexPath) as? ParticleDeviceTableViewCell else {
                    return UITableViewCell()
                }
                
                cell.accessoryType = .DisclosureIndicator
                cell.device = devices[indexPath.row]
                return cell
                
            case 1: // Log Out
                
                let cell = TableCell.Basic.dequeue(tableView, forIndexPath: indexPath)
                cell.textLabel?.text = "Log Out"
                cell.textLabel?.textColor = UIColor.redColor()
                return cell
                
            default: return UITableViewCell()
            }
        }
        
        // Logged Out
        else {
            switch indexPath.section {
                
            case 0: // Auth info
                
                    guard let cell = TableCell.LabelTextField.dequeue(tableView, forIndexPath: indexPath) as? LabelTextFieldTableViewCell else {
                        return UITableViewCell()
                    }
                    cell.selectionStyle = .None
                    
                    switch indexPath.row {
                    case 0:
                        cell.label.text = "Email Address"
                        cell.textField.keyboardType = .EmailAddress
                        return cell
                    case 1:
                        cell.label.text = "Password"
                        cell.textField.secureTextEntry = true
                        return cell
                    default: return cell
                    }
                
            case 1: // Log In
                
                let cell = TableCell.Basic.dequeue(tableView, forIndexPath: indexPath)
                cell.textLabel?.text = "Log In"
                cell.textLabel?.textColor = UIColor.blackColor()
                return cell
                
            default: return UITableViewCell()
            }
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if User.currentUser.isLoggedInToParticle {
            if section == 0 {
                return "Devices"
            }
        }
        return nil
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        if User.currentUser.isLoggedInToParticle {
            switch indexPath.section {
            case 0: // Devices
                let device = devices[indexPath.row]
                guard device.connected else {
                    return
                }
                if let viewController = storyboard?.instantiateViewControllerWithIdentifier(DeviceDetailTableViewController.StoryboardIdentifier) as? DeviceDetailTableViewController
                {
                    viewController.device = device
                    navigationController?.pushViewController(viewController, animated: true)
                }
            case 1: // Log Out
                logOutParticleUser()
            default: return
            }
        } else {
            guard indexPath.section != 0 else { return }
            logInParticleUser()
        }
    }
    
    private func logInParticleUser()
    {
        let emailIP = NSIndexPath(forRow: 0, inSection: 0)
        let passwordIP = NSIndexPath(forRow: 1, inSection: 0)
        
        // Make sure cells exist
        guard let emailCell = tableView.cellForRowAtIndexPath(emailIP) as? LabelTextFieldTableViewCell,
            passwordCell = tableView.cellForRowAtIndexPath(passwordIP) as? LabelTextFieldTableViewCell else {
                return
        }
        
        // Make sure text isn't empty
        guard let emailText = emailCell.textField.text?.stringByReplacingOccurrencesOfString(" ", withString: ""),
            passwordText = passwordCell.textField.text else {
                print("email or password is empty")
                return
        }
        
        User.currentUser.particleAccount.loginWithUser(emailText, password: passwordText) { (error: NSError?) -> Void in
            if self.presentedModally {
                self.dismissViewControllerAnimated(true, completion: nil)
            } else {
                self.tableView.reloadData()
                let set = NSMutableIndexSet()
                set.addIndex(0)
                self.tableView.reloadSections(set, withRowAnimation: .Automatic)
                
                self.navigationItem.title = User.currentUser.loggedInParticleUsername
            }
        }
    }
    
    private func logOutParticleUser()
    {
        User.currentUser.particleAccount.logout()
        
        navigationItem.title = "Particle"
        
        tableView.reloadData()
        let set = NSMutableIndexSet()
        set.addIndex(0)
        set.addIndex(1)
        tableView.reloadSections(set, withRowAnimation: .Automatic)
    }
}
