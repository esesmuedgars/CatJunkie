//
//  CatCell.swift
//  CatJunkie-iOS
//
//  Created by e.vanags on 21/05/2019.
//  Copyright © 2019 esesmuedgars. All rights reserved.
//

import UIKit

@IBDesignable
final class CatCell: UICollectionViewCell {

    @IBInspectable
    var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }

    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!

    override func prepareForReuse() {
        super.prepareForReuse()

        imageView.image = nil

        activityIndicator.startAnimating()
    }

    func configure(with identifier: String, data: NSData?) {
        if let data = data as Data? {
            imageView.image = UIImage(data: data)
        } else {
            imageView.image = nil
        }

        activityIndicator.stopAnimating()
    }
}
