//
//  GalleryImage.swift
//  ImageGallery
//
//  Created by Ivan Tchernev on 20/02/2018.
//  Copyright © 2018 AND Digital. All rights reserved.
//

import Foundation
import UIKit
struct GalleryImage {
    let url: URL
    let aspectRatio: Double
    
    init(_ uiImage: UIImage, withURL url: URL) {
        self.url = url
        if let image = uiImage.cgImage {
            aspectRatio = Double(image.width) / Double(image.height)
        } else {
            aspectRatio = 0.0
        }
    }
}
