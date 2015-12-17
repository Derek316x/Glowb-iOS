//
//  UIViewController+Embed.swift
//  GlowFrame
//
//  Created by Michael Kavouras on 12/16/15.
//  Copyright © 2015 Michael Kavouras. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func embedViewController(viewController: UIViewController, inView containerView: UIView) {
        viewController.view.frame = containerView.bounds
        containerView.insertSubview(viewController.view, atIndex: 0)
        addChildViewController(viewController)
        viewController.didMoveToParentViewController(self)
    }
}