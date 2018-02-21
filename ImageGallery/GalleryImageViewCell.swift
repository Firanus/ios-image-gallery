//
//  GalleryImageViewCell.swift
//  ImageGallery
//
//  Created by Ivan Tchernev on 20/02/2018.
//  Copyright © 2018 AND Digital. All rights reserved.
//

import UIKit

class GalleryImageViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var imageView = UIImageView()
    var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            imageView.contentMode = .scaleAspectFit
            imageView.frame.size = self.bounds.size
            self.addSubview(imageView)
            activityIndicator.stopAnimating()
        }
    }
    
}
