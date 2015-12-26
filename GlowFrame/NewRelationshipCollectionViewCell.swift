//
//  NewRelationshipCollectionViewCell.swift
//  GlowFrame
//
//  Created by Michael Kavouras on 12/19/15.
//  Copyright © 2015 Michael Kavouras. All rights reserved.
//

import UIKit

class NewRelationshipCollectionViewCell: UICollectionViewCell {
    
    var newItemButtonTappedHandler: (() -> Void)?
    
    @IBAction func newItemButtonTapped(sender: AnyObject)
    {
        if let handler = newItemButtonTappedHandler {
            handler()
        }
    }
    
    class var CellIdentifier: String
    {
        return "NewRelationshipCellIdentifier"
    }
    
    class var NibName: String
    {
        return "NewRelationshipCollectionViewCell"
    }
    
    class var Nib: UINib
    {
        return UINib(nibName: NibName, bundle: nil)
    }
}
