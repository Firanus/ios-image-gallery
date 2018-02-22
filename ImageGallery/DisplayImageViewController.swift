//
//  DisplayImageViewController.swift
//  ImageGallery
//
//  Created by Ivan Tchernev on 20/02/2018.
//  Copyright © 2018 AND Digital. All rights reserved.
//

import UIKit

class DisplayImageViewController: UIViewController, UIScrollViewDelegate {

    var galleryImage: GalleryImage? {
        didSet {
            imageView.image = nil
            activityIndicator?.startAnimating()
            galleryImage?.fetchImage { [weak self] image in
                DispatchQueue.main.async {
                    self?.image = image
                }
            }
        }
    }
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.addSubview(imageView)
            scrollView.delegate = self
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    var imageView = UIImageView()
    
    var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            imageView.contentMode = .scaleAspectFit
            imageView.sizeToFit()
            scrollView.contentSize = imageView.frame.size
            setZoomScales(for: scrollView.frame.size)
            activityIndicator.stopAnimating()
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        setZoomScales(for: size)
    }
    
    private func setZoomScales(for size: CGSize) {
        if let image = imageView.image?.cgImage {
            let imageWidth = CGFloat(image.width)
            scrollView.minimumZoomScale = imageWidth > size.width ? size.width / imageWidth : 1
            scrollView.maximumZoomScale = imageWidth > size.width ? 1 : size.width / imageWidth
        } else {
            scrollView.minimumZoomScale = 1
            scrollView.maximumZoomScale = 1
        }
        
    }
}
