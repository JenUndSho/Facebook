//
//  CreatePostView.swift
//  Facebook-iOS
//
//  Created by Evhenii Shovkovyi on 27.03.2024.
//

import Foundation
import UIKit

protocol AddPhotoCollectionViewCellDelegate: AnyObject {
    func didTapAddImage(in cell: UICollectionViewCell)
}

protocol UpdatePhotoCollectionViewCellDelegate: AnyObject {
    func didTapCancelUploadImage(in cell: UICollectionViewCell)
    func didTapUploadImage(in cell: UICollectionViewCell)
}

protocol CreatePostViewProtocol {
    var delegate: CreatePostViewDelegate? { get set }
    var view: UIView { get }
    func setUpNavigationBar(for navigationItem: UINavigationItem)
    func setUserData(with user: User)
    func addImageToCreatePostImages(image: UIImage)
    func setUpTabBarAppearance(navigationController: UINavigationController?, shouldShow: Bool)
}

@objc
protocol CreatePostViewActionProtocol {
    func didTapPostButton()
}

@objc
protocol CreatePostViewDelegate {
    func selectImage()
    func postFeed(images: [UIImage], message: String)
    func displayAlert(with text: String)
}

class CreatePostView: UIView {

    enum Section {
        case main
    }

    weak var delegate: CreatePostViewDelegate?
    private var dataSource: UICollectionViewDiffableDataSource<Section, UIImage>!
    private var selectedIndex: Int = 0

    private var createPostImages: [UIImage] = [UIImage()] {
        didSet {
            updateDataSource()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    convenience init() {
        self.init(frame: .zero)
        setupLayout()
        setupDataSource()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var navigationTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Create Post"
        label.font = .robotoBold(size: 14)
        label.textColor = .black
        return label
    }()

    private lazy var postButton: UIBarButtonItem = {
        let customButton = UIButton(type: .system)
        customButton.addTarget(self, action: #selector(didTapPostButton), for: .touchUpInside)
        customButton.translatesAutoresizingMaskIntoConstraints = false
        customButton.setTitle(NSLocalizedString("Post", comment: ""), for: .normal)
        customButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        customButton.setTitleColor(.black, for: .normal)
        return UIBarButtonItem(customView: customButton)
    }()

    private lazy var navigationHeader: UIView = {
        let localView = UIView()
        localView.translatesAutoresizingMaskIntoConstraints = false
        return localView
    }()

    private lazy var userProfilePhoto: UIImageView = {
        let localImage = UIImageView()
        localImage.translatesAutoresizingMaskIntoConstraints = false
        localImage.layer.masksToBounds = true
        localImage.layer.cornerRadius = 10
        return localImage
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        label.textColor = .black
        label.font = .robotoBoldItalic(size: 14)
        return label
    }()

    private lazy var textCommentView: UITextView = {
        let localTextView = UITextView()
        localTextView.translatesAutoresizingMaskIntoConstraints = false
        localTextView.textContainerInset = UIEdgeInsets(top: Constants.textViewContentInset,
                                                        left: Constants.textViewContentInset,
                                                        bottom: Constants.textViewContentInset,
                                                        right: Constants.textViewContentInset)
        localTextView.backgroundColor = .lightGrayCustom
        localTextView.placeholder = NSLocalizedString("What’s on your mind?", comment: "")
        localTextView.placeholderColor = .grayPlaceholderCustom
        localTextView.layer.cornerRadius = 10
        localTextView.font = .robotoRegular(size: 16)
        localTextView.textContainer.lineFragmentPadding = .zero
        localTextView.textColor = .black
        localTextView.isEditable = true
        localTextView.dataDetectorTypes = .link
        return localTextView
    }()

    private lazy var uploadImageCollectionView: UICollectionView = {
        let localView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        localView.translatesAutoresizingMaskIntoConstraints = false
        localView.backgroundColor = .white
        localView.isScrollEnabled = true
        localView.delegate = self
        localView.dataSource = dataSource
        localView.register(AddPhotoCollectionViewCell.self)
        localView.register(UpdatePhotoCollectionViewCell.self)
        return localView
    }()

    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: uploadImageCollectionView,
                                                        cellProvider: { uploadImageCollectionView, indexPath, image -> UICollectionViewCell? in
            if let image = self.createPostImages[safe: indexPath.row],
               !image.size.equalTo(CGSize(width: 0.0, height: 0.0)) {
                let cell = uploadImageCollectionView.dequeue(UpdatePhotoCollectionViewCell.self, indexPath: indexPath)
                cell.setupCell(image: image)
                cell.delegate = self
                return cell
            } else {
                let cell = uploadImageCollectionView.dequeue(AddPhotoCollectionViewCell.self, indexPath: indexPath)
                cell.delegate = self
                return cell
            }
        })
        updateDataSource()
    }

    private func updateDataSource() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, UIImage>()
        snapshot.appendSections([.main])
        snapshot.appendItems(createPostImages)
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    private func setupLayout() {
        backgroundColor = .white

        addSubview(navigationHeader)
        addSubview(userProfilePhoto)
        addSubview(nameLabel)
        addSubview(textCommentView)
        addSubview(uploadImageCollectionView)

        NSLayoutConstraint.activate([
            navigationHeader.leftAnchor.constraint(equalTo: leftAnchor),
            navigationHeader.topAnchor.constraint(equalTo: topAnchor),
            navigationHeader.rightAnchor.constraint(equalTo: rightAnchor),
            navigationHeader.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.1),

            userProfilePhoto.leftAnchor.constraint(equalTo: leftAnchor, constant: Constants.leadingOffset),
            userProfilePhoto.topAnchor.constraint(equalTo: navigationHeader.bottomAnchor, constant: Constants.innerOffset),
            userProfilePhoto.heightAnchor.constraint(equalTo: widthAnchor, multiplier: Constants.profileSizeMultiplier),
            userProfilePhoto.widthAnchor.constraint(equalTo: widthAnchor, multiplier: Constants.profileSizeMultiplier),

            nameLabel.leftAnchor.constraint(equalTo: userProfilePhoto.rightAnchor, constant: Constants.innerOffset),
            nameLabel.topAnchor.constraint(equalTo: navigationHeader.bottomAnchor, constant: Constants.innerOffset),
            nameLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -Constants.leadingOffset),
            nameLabel.heightAnchor.constraint(equalTo: userProfilePhoto.heightAnchor),

            textCommentView.leftAnchor.constraint(equalTo: leftAnchor, constant: Constants.leadingOffset),
            textCommentView.rightAnchor.constraint(equalTo: rightAnchor, constant: -Constants.leadingOffset),
            textCommentView.topAnchor.constraint(equalTo: userProfilePhoto.bottomAnchor, constant: Constants.innerOffset),
            textCommentView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.3),

            uploadImageCollectionView.leftAnchor.constraint(equalTo: textCommentView.leftAnchor),
            uploadImageCollectionView.topAnchor.constraint(equalTo: textCommentView.bottomAnchor, constant: Constants.textViewToImageOffset),
            uploadImageCollectionView.rightAnchor.constraint(equalTo: textCommentView.rightAnchor),
            uploadImageCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private struct Constants {
        static let paddingNavigationButtons: CGFloat = 20
        static let leadingOffset: CGFloat = 15
        static let innerOffset: CGFloat = 15
        static let profileSizeMultiplier: CGFloat = 0.15
        static let minHeight: CGFloat = 0
        static let defaultImageHeight: CGFloat = 210.0
        static let textViewContentInset: CGFloat = 12
        static let textViewToImageOffset: CGFloat = 23
        static let imageExist: String = "This image is already picked. Please choose another one"
    }
}

extension CreatePostView: CreatePostViewProtocol {
    
    func setUserData(with user: User) {
        userProfilePhoto.downloadImage(from: user.picture.data.url) {
            self.userProfilePhoto.image = UIImage(named: PhotoType.profile.defaultImage)
        }
        nameLabel.text = user.getUserFirsNameAndLastName()
    }

    var view: UIView {
        return self
    }

    func setUpNavigationBar(for navigationItem: UINavigationItem) {
        navigationItem.titleView = navigationTitleLabel
        navigationItem.rightBarButtonItem = postButton
    }

    func addImageToCreatePostImages(image: UIImage) {

        guard !isImageAdded(image: image) else {
            delegate?.displayAlert(with: Constants.imageExist)
            return
        }

        if selectedIndex == (createPostImages.count - 1) {
            createPostImages.insert(image, at: selectedIndex)
        } else {
            createPostImages[selectedIndex] = image
        }
    }

    func setUpTabBarAppearance(navigationController: UINavigationController?, shouldShow: Bool) {
        navigationController?.tabBarController?.tabBar.isHidden = !shouldShow
    }
}

extension CreatePostView: CreatePostViewActionProtocol {
    func didTapPostButton() {
        textCommentView.endEditing(true)
        delegate?.postFeed(images: createPostImages, message: textCommentView.text)
    }
}

extension CreatePostView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }

}

extension CreatePostView: AddPhotoCollectionViewCellDelegate {
    func didTapAddImage(in cell: UICollectionViewCell) {
        textCommentView.endEditing(true)
        guard let indexPath = uploadImageCollectionView.indexPath(for: cell) else {
            return
        }

        selectedIndex = indexPath.row
        delegate?.selectImage()
    }
}

extension CreatePostView: UpdatePhotoCollectionViewCellDelegate {

    func didTapCancelUploadImage(in cell: UICollectionViewCell) {
        guard let indexPath = uploadImageCollectionView.indexPath(for: cell) else {
            return
        }

        if createPostImages.count > 1 {
            createPostImages.remove(at: indexPath.row)
        }
    }

    func didTapUploadImage(in cell: UICollectionViewCell) {
        didTapAddImage(in: cell)
    }

}

private extension CreatePostView {
    func imageHash(image: UIImage) -> Int? {
        guard let imageData = image.pngData() else {
            return nil
        }

        return imageData.hashValue
    }

    func isImageAdded(image: UIImage) -> Bool {
        guard let hash = imageHash(image: image) else {
            return false
        }

        let imageList = createPostImages.compactMap { imageHash(image: $0) }
        return imageList.contains(hash)
    }
}
