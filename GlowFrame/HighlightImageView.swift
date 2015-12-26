//
//  HighlightImageView.swift
//  GlowFrame
//
//  Created by Michael Kavouras on 12/23/15.
//  Copyright © 2015 Michael Kavouras. All rights reserved.
//

import UIKit

class HighlightImageView: UIImageView {
    
    let highlightLayer = CALayer()

    var cornerRadius: CGFloat = 0 {
        didSet {
            highlightLayer.cornerRadius = cornerRadius
            layer.cornerRadius = cornerRadius
        }
    }
    
    var highlightColor: UIColor = UIColor.whiteColor() {
        didSet {
            highlightLayer.borderColor = highlightColor.colorWithAlphaComponent(highlightAlpha).CGColor
        }
    }
    
    var highlightAlpha: CGFloat = 0.0 {
        didSet {
            highlightLayer.borderColor = highlightColor.colorWithAlphaComponent(highlightAlpha).CGColor
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
        highlightLayer.borderColor = UIColor.whiteColor().colorWithAlphaComponent(0.2).CGColor
        highlightLayer.borderWidth = 1.0
        
        layer.addSublayer(highlightLayer)
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        highlightLayer.frame = CGRect(x: -1, y: 0, width: frame.size.width + 2, height: frame.size.height + 2)
    }
}
