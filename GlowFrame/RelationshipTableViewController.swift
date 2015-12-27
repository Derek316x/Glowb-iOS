//
//  RelationshipTableViewController.swift
//  GlowFrame
//
//  Created by Michael Kavouras on 12/26/15.
//  Copyright © 2015 Michael Kavouras. All rights reserved.
//

import UIKit

class RelationshipTableViewController: UITableViewController {
    
    class var StoryboardIdentifier: String {
         return "RelationshipTableViewIdentifier"
    }
    
    override func viewDidLoad()
    {
        setup()
        super.viewDidLoad()
    }
    
    private func setup()
    {
        setupTableView()
        setupNavigationBar()
    }
    
    private func setupTableView()
    {
        tableView.registerNib(TableCell.Basic.Nib, forCellReuseIdentifier: TableCell.Basic.Identifier)
        tableView.registerNib(TableCell.LabelTextField.Nib, forCellReuseIdentifier: TableCell.LabelTextField.Identifier)
    }
    
    private func setupNavigationBar()
    {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "dismiss")
    }
    
    @objc private func dismiss() {
        dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return User.currentUser.devices.count
        case 2: return 3
        default: return 0
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            if let cell = TableCell.LabelTextField.dequeue(tableView, forIndexPath: indexPath) as? LabelTextFieldTableViewCell {
                cell.label.text = "Name"
                cell.textField.placeholder = "Required"
                return cell
            }
            return UITableViewCell()
        case 1:
            let cell = TableCell.Basic.dequeue(tableView, forIndexPath: indexPath)
            let device = Array(User.currentUser.devices)[indexPath.row];
            cell.textLabel?.text = device.name
            return cell
        case 2:
            let cell = TableCell.Basic.dequeue(tableView, forIndexPath: indexPath)
            switch indexPath.row {
            case 0: cell.textLabel?.text = "Blue"
            case 1: cell.textLabel?.text = "Red"
            case 2: cell.textLabel?.text = "Purple"
            default: break
            }
            return cell
        default: return UITableViewCell()
        }

    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Name"
        case 1: return "Device"
        case 2: return "Color"
        default: return nil
        }
    }

}
