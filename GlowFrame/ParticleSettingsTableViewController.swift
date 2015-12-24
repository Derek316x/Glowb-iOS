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

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func signInButtonTapped(sender: AnyObject) {
        guard let email = emailTextField.text,
            password = passwordTextField.text else {
                return
        }
        
        let emailAddress = email.stringByReplacingOccurrencesOfString(" ", withString: "")
        SparkCloud.sharedInstance().loginWithUser(emailAddress, password: password) { (error: NSError!) -> Void in
            SparkCloud.sharedInstance().getDevices({ (devices: [AnyObject]!, error: NSError!) -> Void in
                print(devices)
            })
        }
    }
}
