//
//  RelationshipTableViewController.swift
//  GlowFrame
//
//  Created by Michael Kavouras on 12/26/15.
//  Copyright © 2015 Michael Kavouras. All rights reserved.
//

import UIKit
import Spark_SDK

struct RelationshipConstructor {
    var image: UIImage?
    var name: String?
    var particleDevice: SparkDevice?
    var settings: DeviceSettings?
    
    
    // TODO: Validation
    
    func build() -> Relationship?
    {
        guard let particleDevice = particleDevice,
            image = image,
            settings = settings,
            name = name else {
                return nil
        }
        
        let device = Device(device: particleDevice, settings: settings)
        let relationship = Relationship(image: image, device: device, name: name)
        
        return relationship
    }
}

class RelationshipTableViewController: UITableViewController,
    UINavigationControllerDelegate,
    UIImagePickerControllerDelegate,
    UITextFieldDelegate {
    
    var constructor = RelationshipConstructor()
    var devices = User.currentUser.devices.sort { $0.name < $1.name }
    var onCreateHandler: (() -> Void)?
    
    @IBOutlet weak var previewImageView: HighlightImageView!
    
    class var StoryboardIdentifier: String {
        return "RelationshipTableViewIdentifier"
    }
    
    
    // MARK: - Life cycle
    
    override func viewDidLoad()
    {
        setup()
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }
    
    
    // MARK: - Setup
    
    private func setup()
    {
        setupTableView()
        setupNavigationBar()
        
        User.currentUser.getDevices { (_, _) -> Void in
            self.devices = User.currentUser.devices.sort { $0.name < $1.name }
            self.tableView.reloadData()
            self.tableView.reloadSections(NSIndexSet(index: 1), withRowAnimation: .Automatic)
        }
    }
    
    private func setupTableView()
    {
        tableView.registerNib(TableCell.Basic.Nib, forCellReuseIdentifier: TableCell.Basic.Identifier)
        tableView.registerNib(TableCell.LabelTextField.Nib, forCellReuseIdentifier: TableCell.LabelTextField.Identifier)
        tableView.registerNib(TableCell.ParticleDevice.Nib, forCellReuseIdentifier: TableCell.ParticleDevice.Identifier)
    }
    
    private func setupNavigationBar()
    {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "dismiss")
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "save")
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.translucent = true
        
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    }
    
    
    // MARK: - Bar button actions
    
    @objc private func dismiss()
    {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @objc private func save()
    {
        guard let relationship = constructor.build() else {
            print("invalid relationship")
            return
        }
        User.currentUser.relationships.append(relationship)
        dismissViewControllerAnimated(true, completion: nil)
        
        if let handler = onCreateHandler {
            handler()
        }
    }
    
    
    // MARK: - IBAction
    
    @IBAction func newImageButtonTapped(sender: AnyObject)
    {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .PhotoLibrary
        picker.view.backgroundColor = UIColor.whiteColor()
        
        presentViewController(picker, animated: true, completion: nil)
    }
    
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return devices.count
        case 2: return 3
        default: return 0
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            if let cell = TableCell.LabelTextField.dequeue(tableView, forIndexPath: indexPath) as? LabelTextFieldTableViewCell {
                cell.theme = .Dark
                cell.label.text = "Name"
                cell.textField.placeholder = "Required"
                cell.selectionStyle = .None
                cell.textField.delegate = self
                return cell
            }
            return UITableViewCell()
        case 1:
            if let cell = TableCell.ParticleDevice.dequeue(tableView, forIndexPath: indexPath) as? ParticleDeviceTableViewCell {
                cell.theme = .Dark
                cell.device = devices[indexPath.row]
                return cell
            }
            return UITableViewCell()
        case 2:
            if let cell = TableCell.Basic.dequeue(tableView, forIndexPath: indexPath) as? BasicTableViewCell {
                cell.theme = .Dark
                switch indexPath.row {
                case 0: cell.textLabel?.text = "Blue"
                case 1: cell.textLabel?.text = "Red"
                case 2: cell.textLabel?.text = "Purple"
                default: break
                }
                return cell
            }
            return UITableViewCell()
        default: return UITableViewCell()
        }

    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return nil
        case 1: return "Device"
        case 2: return "Color"
        default: return nil
        }
    }
    
    
    // MARK: - Table view delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 {
            let device = devices[indexPath.row]
            guard device.connected else {
                return
            }
            constructor.particleDevice = devices[indexPath.row]
        }
        
        if indexPath.section == 2 {
            let color: String = ["blue", "red", "purple"][indexPath.row]
            constructor.settings = DeviceSettings(color: color)
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    // MARK: - Image picker controller delegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?)
    {
        previewImageView.image = image
        constructor.image = image
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: - Text field delegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        constructor.name = textField.text
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        constructor.name = textField.text
        textField.resignFirstResponder()
    }
    
    
    // MARK: - Scroll view delegate
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
    
    // MARK: - Utility
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
