//
//  GalleryRowTableViewCell.swift
//  ImageGallery
//
//  Created by Ivan Tchernev on 26/02/2018.
//  Copyright © 2018 AND Digital. All rights reserved.
//

import UIKit

class GalleryRowTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var textContentView: UIView! {
        didSet {
            let tapGestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(GalleryRowTableViewCell.editTextField))
            tapGestureRecogniser.numberOfTapsRequired = 2
            textContentView.addGestureRecognizer(tapGestureRecogniser)
        }
    }
    
    @IBOutlet weak var textField: UITextField! {
        didSet {
            textField.delegate = self
            textField.isUserInteractionEnabled = false
        }
    }
    
    var resignationHandler: (() -> Void)?
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.isUserInteractionEnabled = false
        resignationHandler?()
    }
    
    @objc func editTextField(tapGestureRecigniser: UITapGestureRecognizer) {
        textField.isUserInteractionEnabled = true
        textField.becomeFirstResponder()
    }
}
