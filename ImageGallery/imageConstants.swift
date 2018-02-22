//
//  imageConstants.swift
//  ImageGallery
//
//  Created by Ivan Tchernev on 22/02/2018.
//  Copyright © 2018 AND Digital. All rights reserved.
//

import Foundation
struct imageConstants {
    
    static let failUrl = URL(string: "http://i0.kym-cdn.com/entries/icons/original/000/000/028/Fail-Stamp-Transparent_copy.jpg")!
    
    static let mandelbrotGallery = ImageGallery(name: "Mandelbrot Set", withImages: [
    GalleryImage(url: URL(string: "https://upload.wikimedia.org/wikipedia/commons/2/21/Mandel_zoom_00_mandelbrot_set.jpg")!, uiImage: nil),
    GalleryImage(url: URL(string: "https://upload.wikimedia.org/wikipedia/commons/e/ee/Mandel_zoom_01_head_and_shoulder.jpg")!, uiImage: nil),
    GalleryImage(url: URL(string: "https://upload.wikimedia.org/wikipedia/commons/5/58/Mandel_zoom_02_seehorse_valley.jpg")!, uiImage: nil),
    GalleryImage(url: URL(string: "https://upload.wikimedia.org/wikipedia/commons/5/5b/Mandel_zoom_03_seehorse.jpg")!, uiImage: nil),
    GalleryImage(url: URL(string: "https://upload.wikimedia.org/wikipedia/commons/b/b5/Mandel_zoom_04_seehorse_tail.jpg")!, uiImage: nil),
    GalleryImage(url: URL(string: "https://upload.wikimedia.org/wikipedia/commons/8/82/Mandel_zoom_05_tail_part.jpg")!, uiImage: nil)
    ])
}
