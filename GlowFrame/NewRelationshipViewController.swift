//
//  NewRelationshipViewController.swift
//  GlowFrame
//
//  Created by Michael Kavouras on 12/21/15.
//  Copyright © 2015 Michael Kavouras. All rights reserved.
//

import UIKit

class NewRelationshipViewController: UIViewController {
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        setup()
    }
    
    private func setup() {
       setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "dismiss")
    }
    
    @objc private func dismiss() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    class var NibName: String {
        return "NewRelationshipViewController"
    }
    
}
