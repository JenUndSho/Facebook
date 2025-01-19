//
//  AddPhotoCollectionViewCell.swift
//  Facebook-iOS
//
//  Created by Evhenii Shovkovyi on 09.05.2024.
//

import Foundation
import UIKit

class AddPhotoCollectionViewCell: UICollectionViewCell, BaseCell {

    weak var delegate: AddPhotoCollectionViewCellDelegate?

    public lazy var uploadImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .grayImagePlaceholder
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.addSubview(centerUploadBackgroundImageView)
        imageView.addSubview(plusUploadImageView)

        let tap = UITapGestureRecognizer(target: self, action: #selector(addImageTapped))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tap)

        return imageView
    }()

    private lazy var centerUploadBackgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "Img_box_duotone_line")
        return imageView
    }()

    private lazy var plusUploadImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "Add_square")
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
    private func addImageTapped() {
        delegate?.didTapAddImage(in: self)
    }

    private func setupLayout() {
        addSubview(uploadImageView)
        NSLayoutConstraint.activate([
            uploadImageView.rightAnchor.constraint(equalTo: rightAnchor),
            uploadImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            uploadImageView.heightAnchor.constraint(equalToConstant: Constants.uploadImageViewHeight),
            uploadImageView.widthAnchor.constraint(equalToConstant: Constants.uploadImageViewHeight),

            centerUploadBackgroundImageView.centerXAnchor.constraint(equalTo: uploadImageView.centerXAnchor),
            centerUploadBackgroundImageView.centerYAnchor.constraint(equalTo: uploadImageView.centerYAnchor),
            centerUploadBackgroundImageView.heightAnchor.constraint(equalToConstant: Constants.centerUploadBackgroundImageViewHeight),
            centerUploadBackgroundImageView.widthAnchor.constraint(equalToConstant: Constants.centerUploadBackgroundImageViewHeight),

            plusUploadImageView.rightAnchor.constraint(equalTo: uploadImageView.rightAnchor, constant: -Constants.innerPlusButtonOffset),
            plusUploadImageView.bottomAnchor.constraint(equalTo: uploadImageView.bottomAnchor, constant: -Constants.innerPlusButtonOffset),
            plusUploadImageView.heightAnchor.constraint(equalToConstant: Constants.plusUploadImageViewHeight),
            plusUploadImageView.widthAnchor.constraint(equalToConstant: Constants.plusUploadImageViewHeight)
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
