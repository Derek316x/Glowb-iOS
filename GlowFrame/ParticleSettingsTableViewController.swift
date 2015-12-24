//
//  ParticleSettingsTableViewController.swift
//  GlowFrame
//
//  Created by Michael Kavouras on 12/24/15.
//  Copyright © 2015 Michael Kavouras. All rights reserved.
//

import UIKit

class ParticleSettingsTableViewController: UITableViewController {
    
    let loggedOutDataSource = ParticleLoggedOutTableViewDataSource()
    let loggedInDataSource = ParticleLoggedInTableViewDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let ip = tableView.indexPathForSelectedRow {
            tableView.deselectRowAtIndexPath(ip, animated: true)
        }
    }
    
    private func setup() {
        if User.currentUser.isLoggedInToParticle {
            navigationItem.title = User.currentUser.loggedInParticleUsername
        } else {
            navigationItem.title = "Particle"
        }
    }
    
    private func setupTableViewDataSource() {
        if User.currentUser.isLoggedInToParticle {
            tableView.dataSource = loggedInDataSource
        } else {
            tableView.dataSource = loggedOutDataSource
        }
        
        tableView.reloadData()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if User.currentUser.isLoggedInToParticle {
            return 1
        } else {
            return 2
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if User.currentUser.isLoggedInToParticle {
            return 1
        } else {
            switch section {
            case 0: return 2
            case 1: return 1
            default: return 0
            }
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if User.currentUser.isLoggedInToParticle {
            let cell = tableView.dequeueReusableCellWithIdentifier("BasicCellIdentifier", forIndexPath: indexPath)
            cell.textLabel?.text = "Log Out"
            cell.textLabel?.textColor = UIColor.redColor()
            return cell
        } else {
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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if User.currentUser.isLoggedInToParticle {
            logOutParticleUser()
        } else {
            guard indexPath.section != 0 else { return }
            logInParticleUser()
        }
        
    }
    
    private func logInParticleUser() {
        let emailIP = NSIndexPath(forRow: 0, inSection: 0)
        let passwordIP = NSIndexPath(forRow: 1, inSection: 0)
        
        guard let emailCell = tableView.cellForRowAtIndexPath(emailIP) as? LabelFieldTableViewCell,
            passwordCell = tableView.cellForRowAtIndexPath(passwordIP) as? LabelFieldTableViewCell else {
                return
        }
        
        User.currentUser.particleAccount.loginWithUser(emailCell.textField.text, password: passwordCell.textField.text) { (error: NSError!) -> Void in
            
            self.tableView.reloadData()
            let set = NSMutableIndexSet()
            set.addIndex(0)
            self.tableView.reloadSections(set, withRowAnimation: .Automatic)
            
            self.navigationItem.title = User.currentUser.loggedInParticleUsername
        }
    }
    
    private func logOutParticleUser() {
        User.currentUser.particleAccount.logout()
        tableView.reloadData()
        let set = NSMutableIndexSet()
        set.addIndex(0)
        set.addIndex(1)
        navigationItem.title = "Particle"
        tableView.reloadSections(set, withRowAnimation: .Automatic)
    }
}
