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
    
    init(url: URL) {
        self.init(url: url, uiImage: nil)
    }
    
    init(url: URL, uiImage: UIImage?) {
        self.url = url
        if let image = uiImage?.cgImage {
            aspectRatio = Double(image.width) / Double(image.height)
        } else {
            aspectRatio = 0.0
        }
    }

    func fetchImage(completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let urlContents = try? Data(contentsOf: self.url.imageURL)
            let imageData = (urlContents != nil ? urlContents! : try! Data(contentsOf: imageConstants.failUrl))
            completion(UIImage(data: imageData))
        }
    }
}
