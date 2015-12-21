//
//  ImageViewCollectionViewCell.swift
//  GlowFrame
//
//  Created by Michael Kavouras on 12/7/15.
//  Copyright © 2015 Michael Kavouras. All rights reserved.
//

import UIKit

class RelationshipCollectionViewCell: UICollectionViewCell, UIScrollViewDelegate {
    
    private let VISIBLE_IMAGE_PORTION: CGFloat = 60.0
    
    var firstLoad = true
    
    var relationship: Relationship? {
        didSet {
            self.imageView.image = relationship!.image
            deviceDetailView.device = relationship?.device
        }
    }
    
    lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .ScaleAspectFill
        iv.layer.cornerRadius = 14.0
        iv.clipsToBounds = true
        return iv
    }()
    
    private lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.pagingEnabled = true
        sv.showsVerticalScrollIndicator = false
        sv.delegate = self
        return sv
    }()
    
    private lazy var deviceDetailView: DeviceManagementView = {
        let v = DeviceManagementView.viewFromNib()!
        return v
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.addSubview(deviceDetailView)
        contentView.addSubview(scrollView)
        scrollView.addSubview(imageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if firstLoad {
            firstLoad = false
            
            deviceDetailView.frame = bounds
            scrollView.frame = bounds
            imageView.frame = bounds
            imageView.frame.origin.y = frame.size.height - VISIBLE_IMAGE_PORTION
            scrollView.contentSize = CGSize(width: frame.size.width, height: frame.size.height * 2.0 - VISIBLE_IMAGE_PORTION)
            scrollView.contentOffset = CGPoint(x: 0, y: frame.size.height - VISIBLE_IMAGE_PORTION)
        }
    }
    
    
    // MARK: - Nib
    
    class var CellIdentifier: String {
        return "RelationshipCellIdentifier"
    }
    
    class var NibName: String {
        return "RelationshipCollectionViewCell"
    }
    
    class var Nib: UINib {
        return UINib(nibName: NibName, bundle: nil)
    }
    
    
    // MARK: - Scroll view delegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        deviceDetailView.loadDeviceInfo()
    }
    
}
