//
//  ViewController.swift
//  GlowFrame
//
//  Created by Michael Kavouras on 12/5/15.
//  Copyright © 2015 Michael Kavouras. All rights reserved.
//

import UIKit
import Spark_SDK

class SettingsTableViewController: UITableViewController {

    @IBOutlet weak var logInOrLoggedInLabel: UILabel!
    
    @IBAction func doneButtonTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if User.currentUser.isLoggedInToParticle {
            logInOrLoggedInLabel.text = User.currentUser.loggedInParticleUsername
        } else {
            logInOrLoggedInLabel.text = "Log In"
        }
        
        if let ip = tableView.indexPathForSelectedRow {
            tableView.deselectRowAtIndexPath(ip, animated: true)
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 0 && indexPath.row == 1 {
            
        }
    }
}

