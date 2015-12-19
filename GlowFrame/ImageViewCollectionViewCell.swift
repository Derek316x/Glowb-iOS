//
//  ImageViewCollectionViewCell.swift
//  GlowFrame
//
//  Created by Michael Kavouras on 12/7/15.
//  Copyright © 2015 Michael Kavouras. All rights reserved.
//

import UIKit

class ImageViewCollectionViewCell: UICollectionViewCell {
    
    lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .ScaleAspectFill
        return iv
    }()
    
    lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.pagingEnabled = true
        sv.showsVerticalScrollIndicator = false
        return sv
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView.layer.cornerRadius = 14.0
        imageView.clipsToBounds = true
        
        contentView.addSubview(scrollView)
        scrollView.addSubview(imageView)

    }
    
    override func layoutSubviews() {
        scrollView.frame = bounds
        imageView.frame = bounds
        imageView.frame.origin.y = frame.size.height
        scrollView.contentSize = CGSize(width: frame.size.width, height: frame.size.height * 2.0)
        scrollView.contentOffset = CGPoint(x: 0, y: frame.size.height)
        super.layoutSubviews()
    }
    
}
