//
//  FeedPostCollectionViewCell.swift
//  Facebook-iOS
//
//  Created by Evhenii Shovkovyi on 06.03.2024.
//

import Foundation
import UIKit

class FeedPostCollectionViewCell: UICollectionViewCell, BaseCell {

    public lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .black

        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func setupCell(image: Image) {
        imageView.downloadImage(from: image.src) {
            self.imageView.image = UIImage(named: PhotoType.profile.defaultImage)
        }
    }

    private func setupLayout() {
        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.leftAnchor.constraint(equalTo: leftAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.rightAnchor.constraint(equalTo: rightAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
