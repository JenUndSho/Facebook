//
//  ProfileAlbumPhotoCollectionViewCell.swift
//  Facebook-iOS
//
//  Created by Evhenii Shovkovyi on 04.05.2024.
//

import Foundation
import UIKit

class ProfileAlbumPhotoCollectionViewCell: UICollectionViewCell, BaseCell {

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
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

    public func setupCell(item: PhotoData) {
        imageView.downloadImage(from: item.picture) {
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
