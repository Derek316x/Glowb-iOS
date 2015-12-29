//
//  DeviceDetailTableViewController.swift
//  GlowFrame
//
//  Created by Michael Kavouras on 12/26/15.
//  Copyright © 2015 Michael Kavouras. All rights reserved.
//

import UIKit
import Spark_SDK

class DeviceDetailTableViewController: UITableViewController,
    UITextFieldDelegate {
    
    var device: SparkDevice!
    
    class var StoryboardIdentifier: String {
        return "DeviceDetailStoryboardIdentifier"
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setup()
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
        
        tableView.backgroundColor = UIColor.blackColor()
        tableView.separatorStyle = .None
    }
    
    private func setupNavigationBar()
    {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "save")
    }
    
    @objc private func save()
    {
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        guard let cell = tableView.cellForRowAtIndexPath(indexPath) as? LabelTextFieldTableViewCell else {
            return
        }
        
        guard let newName = cell.textField.text else {
            return
        }
        
        device.rename(newName) { (error: NSError?) -> Void in
            guard error == nil else { return }
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return (device.functions?.count ?? 0) == 0 ? 1 : 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        switch section {
        case 0: return 1
        case 1: return device.functions?.count ?? 0
        default: return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        switch indexPath.section {
        case 0:
            guard let cell = TableCell.LabelTextField.dequeue(tableView, forIndexPath: indexPath) as? LabelTextFieldTableViewCell else {
                return UITableViewCell()
            }
            cell.theme = .Dark
            cell.label.text = "Name"
            cell.textField.text = device.name
            cell.textField.backgroundColor = UIColor.blackColor()
            cell.textField.delegate = self
            cell.textField.clearButtonMode = .WhileEditing
            return cell
        case 1:
            guard let cell = TableCell.Basic.dequeue(tableView, forIndexPath: indexPath) as? BasicTableViewCell else {
                return UITableViewCell()
            }
            cell.theme = .Dark
            cell.selectionStyle = .None
            cell.textLabel?.text = device.functions?[indexPath.row] as? String
            return cell
        default: return UITableViewCell()
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return nil
        case 1: return "Functions"
        default: return nil
        }
    }
    
    
    // MARK: - Text field delegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    // MARK: - Utility
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

}
