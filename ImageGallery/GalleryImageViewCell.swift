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
    var galleryImage: GalleryImage? {
        didSet {
            let url = galleryImage?.url
            galleryImage?.fetchImage { [weak self] image in
                DispatchQueue.main.async {
                    if let realSelf = self, url == self?.galleryImage?.url {
                        realSelf.imageView.image = image
                        realSelf.imageView.contentMode = .scaleAspectFit
                        realSelf.imageView.frame.size = realSelf.bounds.size
                        realSelf.addSubview(realSelf.imageView)
                        realSelf.activityIndicator.stopAnimating()
                    }
                }
            }
        }
    }
}
