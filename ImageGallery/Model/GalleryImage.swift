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
    var aspectRatio: Double
    
    init() {
        aspectRatio = 0.0
        url = URL(string: "https://upload.wikimedia.org/wikipedia/commons/2/21/Mandel_zoom_00_mandelbrot_set.jpg")!
    }
    
    init(_ uiImage: UIImage, withURL url: URL) {
        self.url = url
        if let image = uiImage.cgImage {
            aspectRatio = Double(image.width) / Double(image.height)
        } else {
            aspectRatio = 0.0
        }
    }

    func fetchImage(completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let urlContents = try? Data(contentsOf: self.url.imageURL)
            if let imageData = urlContents {
                completion(UIImage(data: imageData))
            }
        }
    }
}
