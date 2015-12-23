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
    private let CORNER_RADIUS: CGFloat = 20.0
    private var _updatingDevice = false
    
    var firstLoad = true
    
    var relationship: Relationship? {
        didSet {
            imageView.image = relationship!.image
            imageBackground.image = relationship!.image
        }
    }
    
    lazy var imageView: HighlightImageView = {
        let iv = HighlightImageView(frame: CGRectZero)
        iv.contentMode = .ScaleAspectFill
        iv.layer.masksToBounds = true
        iv.cornerRadius = self.CORNER_RADIUS
        
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
        v.backgroundColor = UIColor.clearColor()
        return v
    }()
    
    private lazy var imageBackground: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .ScaleAspectFill
        iv.alpha = 0.45
        return iv
    }()
    
    private lazy var visualBackground: UIVisualEffectView = {
        let effect = UIBlurEffect(style: .Dark)
        let v = UIVisualEffectView(effect: effect)
        v.transform = CGAffineTransformMakeScale(2.0, 2.0)
        return v
    }()
    
    private lazy var background: UIView = {
        let v = UIView()
        v.layer.cornerRadius = self.CORNER_RADIUS
        v.layer.masksToBounds = true
        return v
    }()
    
    private lazy var overlayView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.blackColor()
        v.alpha = 0.0
        v.layer.cornerRadius = self.CORNER_RADIUS
        v.layer.masksToBounds = true
        return v
    }()
    
    private lazy var shadowView: UIView = {
        let v = UIView()
        v.layer.shadowColor = UIColor.blackColor().CGColor
        v.layer.shadowOffset = CGSize(width: 0.0, height: -4.0)
        v.layer.shadowOpacity = 0.32
        v.layer.shadowRadius = 12.0
        v.backgroundColor = UIColor.blackColor()
        v.layer.cornerRadius = self.CORNER_RADIUS
        return v
    }()
    
    
    // MARK: - Life cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        background.addSubview(imageBackground)
        background.addSubview(visualBackground)
        
        contentView.addSubview(background)
        contentView.addSubview(deviceDetailView)
        contentView.addSubview(scrollView)
        
        scrollView.addSubview(shadowView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(overlayView)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        background.frame = bounds
        deviceDetailView.frame = bounds
        scrollView.frame = bounds
        imageBackground.frame = bounds
        visualBackground.frame = bounds
        
        if firstLoad {
            firstLoad = false
            
            imageView.frame = bounds
            overlayView.frame = bounds
            shadowView.frame = bounds
            
            imageView.frame.origin.y = frame.size.height - VISIBLE_IMAGE_PORTION
            overlayView.frame.origin.y = frame.size.height - VISIBLE_IMAGE_PORTION
            shadowView.frame.origin.y = frame.size.height - VISIBLE_IMAGE_PORTION
            
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
    
    
    // MARK: - Imparative
    
    func eagerLoad() {
        updateDeviceInfo()
    }
    
    func resetScroll() {
        scrollView.setContentOffset(CGPoint(x: 0, y: frame.size.height - VISIBLE_IMAGE_PORTION), animated: true)
    }
    
    private func updateDeviceInfo(force: Bool = false) {
        relationship?.device.updateInfo(force, completion: { (device: Device) -> Void in
            self.deviceDetailView.displayDevice(device)
            self.relationship!.device = device
            self._updatingDevice = false
        })
    }
    
    
    // MARK: - Scroll view delegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let alpha = (scrollView.contentOffset.y + VISIBLE_IMAGE_PORTION) / frame.size.height
        overlayView.alpha = (1 - alpha) * 0.8
        
        background.alpha = 1 - alpha
        
        
        // pull to refresh
        
        guard !_updatingDevice else { return }
        _updatingDevice = true
        
        updateDeviceInfo()
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y < -VISIBLE_IMAGE_PORTION {
            updateDeviceInfo(true)
        }
    }
    
}
