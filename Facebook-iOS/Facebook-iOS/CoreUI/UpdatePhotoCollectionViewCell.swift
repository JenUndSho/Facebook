//
//  UpdatePhotoCollectionViewCell.swift
//  Facebook-iOS
//
//  Created by Evhenii Shovkovyi on 09.05.2024.
//

import Foundation
import UIKit

class UpdatePhotoCollectionViewCell: UICollectionViewCell, BaseCell {

    weak var delegate: UpdatePhotoCollectionViewCellDelegate?

    private lazy var uploadImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .grayImagePlaceholder
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10

        let tap = UITapGestureRecognizer(target: self, action: #selector(uploadImageTapped))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tap)

        return imageView
    }()

    private lazy var cancelUploadImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "Close_round_fill")

        let tap = UITapGestureRecognizer(target: self, action: #selector(cancelUploadImageTapped))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tap)

        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc
    private func cancelUploadImageTapped() {
        delegate?.didTapCancelUploadImage(in: self)
    }

    @objc
    private func uploadImageTapped() {
        delegate?.didTapUploadImage(in: self)
    }

    public func setupCell(image: UIImage) {
        uploadImageView.image = image
        layoutIfNeeded()
    }

    private func setupLayout() {
        addSubview(uploadImageView)
        addSubview(cancelUploadImageView)
        NSLayoutConstraint.activate([
            uploadImageView.rightAnchor.constraint(equalTo: rightAnchor),
            uploadImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            uploadImageView.heightAnchor.constraint(equalToConstant: Constants.uploadImageViewHeight),
            uploadImageView.widthAnchor.constraint(equalToConstant: Constants.uploadImageViewHeight),

            cancelUploadImageView.topAnchor.constraint(equalTo: uploadImageView.topAnchor, constant: -Constants.cancelImageViewOffset),
            cancelUploadImageView.leftAnchor.constraint(equalTo: uploadImageView.leftAnchor, constant: -Constants.cancelImageViewOffset)
        ])
    }

    private struct Constants {
        static let leadingOffset: CGFloat = 15
        static let innerPlusButtonOffset: CGFloat = 6
        static let uploadImageViewHeight: CGFloat = 90
        static let centerUploadBackgroundImageViewHeight: CGFloat = 40
        static let plusUploadImageViewHeight: CGFloat = 24
        static let cancelImageViewOffset: CGFloat = 12
    }

}
