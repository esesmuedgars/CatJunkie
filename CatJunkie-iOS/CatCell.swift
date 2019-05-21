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

        activityIndicator.startAnimating()
    }

    func configure(with model: Cat) {
        // TODO: Cache previously initiated `UIImage`

        backgroundThread { [weak self] in
            let image = UIImage(url: model.url)

            mainThread {
                self?.imageView.image = image
                self?.activityIndicator.stopAnimating()
            }
        }
    }
}
