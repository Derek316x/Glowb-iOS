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

    @IBAction func doneButtonTapped(sender: AnyObject)
    {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        User.currentUser.getDevices(nil)
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        if let ip = tableView.indexPathForSelectedRow {
            tableView.deselectRowAtIndexPath(ip, animated: true)
        }
        
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        switch section {
        case 0: return 1
        case 1: return User.currentUser.relationships.count
        default: return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("BasicCellIdentifier", forIndexPath: indexPath)
            cell.textLabel?.text = "Log In"
            if User.currentUser.isLoggedInToParticle {
                cell.textLabel?.text = User.currentUser.loggedInParticleUsername
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("BasicCellIdentifier", forIndexPath: indexPath)
            cell.textLabel?.text = User.currentUser.relationships[indexPath.row].nickname
            return cell
        default: return UITableViewCell()
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        if indexPath.section == 0 && indexPath.row == 0 {
            if let viewController = storyboard?.instantiateViewControllerWithIdentifier(ParticleSettingsTableViewController.StoryboardIdentifier) as? ParticleSettingsTableViewController {
                navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Particle Account"
        case 1: return "Relationships"
        default: return nil
        }
    }
}

