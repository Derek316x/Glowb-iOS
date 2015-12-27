//
//  HighlightImageView.swift
//  GlowFrame
//
//  Created by Michael Kavouras on 12/23/15.
//  Copyright © 2015 Michael Kavouras. All rights reserved.
//

import UIKit

@IBDesignable
class HighlightImageView: DesignableImageView {
    
    let highlightLayer = CALayer()

    @IBInspectable
    override var cornerRadius: CGFloat {
        didSet {
            highlightLayer.cornerRadius = cornerRadius
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable
    var highlightColor: UIColor = UIColor.whiteColor() {
        didSet {
            highlightLayer.borderColor = highlightColor.colorWithAlphaComponent(highlightAlpha).CGColor
        }
    }
    
    @IBInspectable
    var highlightAlpha: CGFloat = 0.0 {
        didSet {
            highlightLayer.borderColor = highlightColor.colorWithAlphaComponent(highlightAlpha).CGColor
        }
    }
    
    @IBInspectable
    var highlightWidth: CGFloat = 0.0 {
        didSet {
            highlightLayer.borderWidth = highlightWidth
        }
    }
    
    override func awakeFromNib()
    {
        setup()
        super.awakeFromNib()
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup()
    {
        clipsToBounds = true
        layer.addSublayer(highlightLayer)
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        highlightLayer.frame = CGRect(x: -1, y: 0, width: frame.size.width + 2, height: frame.size.height + 2)
    }
}
