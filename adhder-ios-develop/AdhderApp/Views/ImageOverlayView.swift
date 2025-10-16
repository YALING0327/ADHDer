//
//  ImageOverlayView.swift
//  Adhder
//
//  Created by Phillip Thelen on 13.04.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import UIKit

class ImageOverlayView: AdhderAlertController {
    
    private var imageView = NetworkImageView()
    private var imageHeightConstraint: NSLayoutConstraint?
    
    var imageName: String? {
        didSet {
            if let imageName = imageName {
                imageView.setImagewith(name: imageName)
            }
        }
    }
    
    var imageHeight: CGFloat? {
        get {
            return imageHeightConstraint?.constant
        }
        set {
            imageHeightConstraint?.constant = newValue ?? 0
            updateViewConstraints()
        }
    }
    
    var image: UIImage? {
        return imageView.image
    }
    
    init(imageName: String, title: String?, message: String? = nil) {
        super.init()
        self.title = title
        self.message = message
        self.imageName = imageName
        setupImageView()
        imageView.setImagewith(name: imageName)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupImageView()
    }

    private func setupImageView() {
        contentView = imageView
        imageView.contentMode = .center
        imageHeightConstraint = NSLayoutConstraint(item: imageView,
                                                   attribute: NSLayoutConstraint.Attribute.height,
                                                   relatedBy: NSLayoutConstraint.Relation.equal,
                                                   toItem: nil,
                                                   attribute: NSLayoutConstraint.Attribute.notAnAttribute,
                                                   multiplier: 1,
                                                   constant: 100)
        if let constraint = imageHeightConstraint {
            imageView.addConstraint(constraint)
        }
    }
}
