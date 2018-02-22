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
    
    private var imageView: UIImageView?
    
    //Is putting the fetch logic here bad? Should I just have an outlet, and move the actual fetching to the controller?
    var galleryImage: GalleryImage? {
        didSet {
            imageView = nil
            let url = galleryImage?.url
            galleryImage?.fetchImage { [weak self] image in
                DispatchQueue.main.async {
                    if url == self?.galleryImage?.url {
                        let imageView = UIImageView(image: image)
                        imageView.contentMode = .scaleAspectFit
                        imageView.frame.size = self?.bounds.size ?? CGSize.zero
                        self?.addSubview(imageView)
                        self?.activityIndicator.stopAnimating()
                    }
                }
            }
        }
    }
    
    //    var galleryImage: GalleryImage? {
    //        didSet {
    //            let url = galleryImage?.url
    //            galleryImage?.fetchImage { [weak self] image in
    //                DispatchQueue.main.async {
    //                    if url == self?.galleryImage?.url {
    //                        self?.image = image
    //                    }
    //                }
    //            }
    //        }
    //    }
    //    private(set) var image: UIImage? {
    //        get {
    //            return imageView.image
    //        }
    //        set {
    //            imageView.image = newValue
    //            imageView.contentMode = .scaleAspectFit
    //            imageView.frame.size = self.bounds.size
    //            self.addSubview(imageView)
    //            activityIndicator.stopAnimating()
    //        }
    //    }
}
