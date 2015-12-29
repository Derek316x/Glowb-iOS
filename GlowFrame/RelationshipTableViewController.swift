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
    var color: String?
    
    // TODO: Validation
    
    func build(existing: Relationship? = nil) -> Relationship?
    {
        guard let particleDevice = self.particleDevice,
            image = self.image,
            color = self.color,
            name = self.name else {
                return nil
        }
        
        if let relationship = existing {
            relationship.image = image
            relationship.device.color = color
            relationship.name = name
            relationship.device.particleDevice = particleDevice
            
            do {
                try relationship.save()
                return relationship
            } catch _ {
                return nil
            }
        } else {
            guard let device = Device.create(particleDevice, color: color),
                relationship = Relationship.create(image, device: device, name: name) else {
                    return nil
            }
            do {
                try relationship.save()
                return relationship
            } catch _ {
                return nil
            }
        }
    }
}

class RelationshipTableViewController: UITableViewController,
    UINavigationControllerDelegate,
    UIImagePickerControllerDelegate,
    UITextFieldDelegate {
    
    @IBOutlet weak var headerImageView: HighlightImageView!
    
    var constructor = RelationshipConstructor()
    
    var devices = User.currentUser.devices.sort { $0.name < $1.name }
    
    var presentedModally: Bool = false
    
    var relationship: Relationship? {
        didSet {
            constructor.name = relationship!.name
            constructor.particleDevice = relationship!.device.particleDevice
            constructor.image = relationship!.image
            constructor.color = relationship!.device.color
        }
    }
    
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
    
    override func viewWillDisappear(animated: Bool)
    {
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
        
        headerImageView.image = relationship?.image
    }
    
    private func setupTableView()
    {
        tableView.registerNib(TableCell.Basic.Nib, forCellReuseIdentifier: TableCell.Basic.Identifier)
        tableView.registerNib(TableCell.LabelTextField.Nib, forCellReuseIdentifier: TableCell.LabelTextField.Identifier)
        tableView.registerNib(TableCell.ParticleDevice.Nib, forCellReuseIdentifier: TableCell.ParticleDevice.Identifier)
    }
    
    private func setupNavigationBar()
    {
        if presentedModally {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "dismiss")
        }
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
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) { () -> Void in
            guard let _ = self.constructor.build(self.relationship) else {
                print("invalid relationship")
                return
            }
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if self.presentedModally {
                    self.dismissViewControllerAnimated(true, completion: nil)
                } else {
                    self.navigationController?.popViewControllerAnimated(true)
                }
            })
        }
    }
    
    
    // MARK: - IBAction
    
    @IBAction func newImageButtonTapped(sender: AnyObject)
    {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .PhotoLibrary
        
        picker.view.backgroundColor = UIColor.whiteColor()
        picker.navigationBar.translucent = false
        picker.navigationBar.tintColor = UIColor.blackColor()
        picker.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.blackColor()]
        
        presentViewController(picker, animated: true, completion: nil)
    }
    
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        switch section {
        case 0: return 1
        case 1: return devices.count
        case 2: return 3
        default: return 0
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        switch indexPath.section {
        case 0:
            if let cell = TableCell.LabelTextField.dequeue(tableView, forIndexPath: indexPath) as? LabelTextFieldTableViewCell {
                cell.theme = .Dark
                cell.label.text = "Name"
                cell.textField.placeholder = "Required"
                cell.textField.text = relationship?.name
                cell.textField.delegate = self
                cell.textField.keyboardAppearance = .Dark
                cell.selectionStyle = .None
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
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        switch section {
        case 0: return nil
        case 1: return "Device"
        case 2: return "Color"
        default: return nil
        }
    }
    
    
    // MARK: - Table view delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        if indexPath.section == 1 {
            let device = devices[indexPath.row]
            guard device.connected else {
                return
            }
            constructor.particleDevice = devices[indexPath.row]
        }
        
        if indexPath.section == 2 {
            constructor.color = ["blue", "red", "purple"][indexPath.row]
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
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        constructor.name = textField.text
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField)
    {
        constructor.name = textField.text
        textField.resignFirstResponder()
    }
    
    
    // MARK: - Scroll view delegate
    
    override func scrollViewDidScroll(scrollView: UIScrollView)
    {
        view.endEditing(true)
    }
    
    
    // MARK: - Utility
    
    override func prefersStatusBarHidden() -> Bool
    {
        return true
    }
}
