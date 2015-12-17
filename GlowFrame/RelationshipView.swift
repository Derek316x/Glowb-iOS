//
//  RelationshipView.swift
//  GlowFrame
//
//  Created by Michael Kavouras on 12/7/15.
//  Copyright © 2015 Michael Kavouras. All rights reserved.
//

import UIKit

class RelationshipView: UIView {

    @IBOutlet weak var imageView: UIImageView!
    
    class func viewFromNib() -> RelationshipView? {
        guard let view = NSBundle.mainBundle().loadNibNamed(self.nibName(), owner: self, options: nil)[0] as? RelationshipView else {
            return nil
        }
        
        return view
    }
    
    private class func nibName() -> String {
        
        return "RelationshipView"
    }
}
