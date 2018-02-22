//
//  ImageGallery.swift
//  ImageGallery
//
//  Created by Ivan Tchernev on 20/02/2018.
//  Copyright © 2018 AND Digital. All rights reserved.
//

import Foundation
class ImageGallery {
    var name: String
    var images: [GalleryImage] = []
    
    private static var identifier = 0
    private static func getDefaultName() -> String {
        identifier += 1
        return "Untitled \(identifier)"
    }
    
    init() {
        name = ImageGallery.getDefaultName()
    }
    
    init(name: String, withImages images: [GalleryImage]){
        self.name = name
        self.images = images
    }
    
    convenience init(withImages images: [GalleryImage]){
        self.init()
        self.images = images
    }
}
