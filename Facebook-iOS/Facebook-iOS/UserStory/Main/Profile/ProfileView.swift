//
//  ProfileView.swift
//  Facebook-iOS
//
//  Created by Evhenii Shovkovyi on 22.02.2024.
//

import Foundation
import UIKit

protocol ProfileViewProtocol {
    var delegate: ProfileViewDelegate? { get set }
    var view: UIView { get }
    func updateProfileImageView(with image: String)
    func updateProfileImageView(with url: URL)
    func updateCoverImageView(with image: String)
    func updateCoverImageView(with url: URL)
    func updateUserProfileData(with user: User)
    func setupNavigationButtons(navigationItem: UINavigationItem)
    func updatePhotoAlbumsCollectionView(with data: PhotoAlbums)
}

@objc
protocol ProfileViewActionProtocol {
    func didTapLogOutButton()
    func didTapAppPostButton()
}

@objc
protocol ProfileViewDelegate: AnyObject {
    func logOut()
    func addPost()
    func removeBackArrowFromBackButton()
}

class ProfileView: UIView {

    enum Section {
        case main
    }

    weak var delegate: ProfileViewDelegate?
    private var dataSource: UICollectionViewDiffableDataSource<Section, PhotoData>!

    private var photos: [PhotoData]?
    private var coverPhotos: [PhotoData]?
    private var profilePictures: [PhotoData]?

    private lazy var headerStackView: UIStackView = {
        let localStackView = UIStackView()
        localStackView.translatesAutoresizingMaskIntoConstraints = false
        localStackView.axis = .vertical
        localStackView.alignment = .center
        return localStackView
    }()

    private lazy var imagesView: UIView = {
        let localView = UIView()
        localView.translatesAutoresizingMaskIntoConstraints = false
        localView.addSubview(navigationImageView)
        localView.addSubview(profileView)
        return localView
    }()

    private lazy var profileView: UIView = {
        let localView = UIImageView()
        localView.translatesAutoresizingMaskIntoConstraints = false
        localView.layer.masksToBounds = true
        localView.layer.cornerRadius = 15
        localView.addSubview(profileImageView)
        localView.backgroundColor = .white
        return localView
    }()

    private lazy var profileImageView: UIImageView = {
        let localView = UIImageView()
        localView.translatesAutoresizingMaskIntoConstraints = false
        localView.layer.masksToBounds = true
        localView.layer.cornerRadius = 15
        localView.addSubview(cameraIconImage)
        return localView
    }()

    private lazy var cameraIconImage: UIImageView = {
        let localView = UIImageView()
        localView.translatesAutoresizingMaskIntoConstraints = false
        localView.image = UIImage(named: "camera_icon")
        return localView
    }()

    private lazy var navigationImageView: UIImageView = {
        let localView = UIImageView()
        localView.translatesAutoresizingMaskIntoConstraints = false
        localView.isUserInteractionEnabled = true
        return localView
    }()

    private lazy var addPostButton: UIBarButtonItem = {
        let customButton = UIButton(type: .system)
        customButton.addTarget(self, action: #selector(didTapAppPostButton), for: .touchUpInside)
        customButton.translatesAutoresizingMaskIntoConstraints = false
        customButton.setTitle(NSLocalizedString("Add post", comment: ""), for: .normal)
        customButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        customButton.setTitleColor(.white, for: .normal)
        let padding: CGFloat = Constants.paddingNavigationButtons
        customButton.widthAnchor.constraint(equalToConstant: customButton.intrinsicContentSize.width + padding).isActive = true
        return UIBarButtonItem(customView: customButton)
    }()

    private lazy var logOutButton: UIBarButtonItem = {
        let customButton = UIButton()
        customButton.addTarget(self, action: #selector(didTapLogOutButton), for: .touchUpInside)
        customButton.translatesAutoresizingMaskIntoConstraints = false
        customButton.setImage(UIImage(named: "log_out_icon"), for: .normal)
        let padding: CGFloat = Constants.paddingNavigationButtons
        customButton.translatesAutoresizingMaskIntoConstraints = false
        customButton.widthAnchor.constraint(equalToConstant: customButton.intrinsicContentSize.width + padding).isActive = true
        return UIBarButtonItem(customView: customButton)
    }()

    private lazy var backCrossSign: UIBarButtonItem = {
        let btn = UIBarButtonItem()
        btn.image = UIImage(named: "close_NavBar_Btn")
        btn.tintColor = .black
        return btn
    }()

    private lazy var userInfoView: UIView = {
        let userView = UIView()
        userView.addSubview(userNameLabel)
        userView.addSubview(bioTextView)
        return userView
    }()

    private lazy var userNameLabel: UILabel = {
        let localLabel = UILabel()
        localLabel.translatesAutoresizingMaskIntoConstraints = false
        localLabel.font = .robotoRegular(size: 24)
        localLabel.textColor = .black
        return localLabel
    }()

    private lazy var bioTextView: UITextView = {
        let localTextView = UITextView()
        localTextView.translatesAutoresizingMaskIntoConstraints = false
        localTextView.backgroundColor = .clear
        localTextView.text = NSLocalizedString("Bio Placeholder", comment: "")
        localTextView.placeholderColor = .black
        localTextView.font = .robotoRegular(size: 14)
        localTextView.textContainer.lineFragmentPadding = .zero
        localTextView.isEditable = false
        localTextView.dataDetectorTypes = .link
        return localTextView
    }()

    private lazy var photoAlbumsTitle: UILabel = {
        let localLabel = UILabel()
        localLabel.translatesAutoresizingMaskIntoConstraints = false
        localLabel.font = .robotoRegular(size: 14)
        localLabel.textColor = .black
        localLabel.text = "My Photo Albums"
        return localLabel
    }()

    private lazy var segmentedControl: UISegmentedControl = {
        let localControl = UISegmentedControl()
        localControl.translatesAutoresizingMaskIntoConstraints = false
        localControl.selectedSegmentTintColor = .white
        localControl.setTitleTextAttributes([.foregroundColor: UIColor.black,
                                             .font: UIFont.boldSystemFont(ofSize: 12)], for: .selected)
        localControl.setTitleTextAttributes([.foregroundColor: UIColor.black,
                                             .font: UIFont.boldSystemFont(ofSize: 12)], for: .normal)
        localControl.addTarget(self, action: #selector(updateDataSource), for: .valueChanged)
        return localControl
    }()

    private lazy var photoAlbumsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        layout.sectionInset = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)

        let localView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        localView.translatesAutoresizingMaskIntoConstraints = false
        localView.backgroundColor = .white
        localView.isScrollEnabled = true
        localView.delegate = self
        localView.dataSource = dataSource
        localView.register(ProfileAlbumPhotoCollectionViewCell.self, forCellWithReuseIdentifier: ProfileAlbumPhotoCollectionViewCell.reuseIdentifier)
        return localView
    }()

    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: photoAlbumsCollectionView,
                                                        cellProvider: { photoAlbumsCollectionView, indexPath, image -> UICollectionViewCell? in

            guard let cell = photoAlbumsCollectionView.dequeueReusableCell(withReuseIdentifier: ProfileAlbumPhotoCollectionViewCell.reuseIdentifier,
                                                                           for:
                                                                            indexPath) as? ProfileAlbumPhotoCollectionViewCell else { return UICollectionViewCell() }
            cell.setupCell(item: image)
            return cell
        })
    }

    @objc
    private func updateDataSource() {
        let itemsToAppend: [PhotoData]?
        switch segmentedControl.selectedSegmentIndex {
        case Constants.photosIndex:
            itemsToAppend = photos
        case Constants.coverPhotosIndex:
            itemsToAppend = coverPhotos
        case Constants.profilePicturesIndex:
            itemsToAppend = profilePictures
        default:
            itemsToAppend = []
        }

        if let photos = itemsToAppend {
            var snapshot = NSDiffableDataSourceSnapshot<Section, PhotoData>()
            snapshot.appendSections([.main])
            snapshot.appendItems(photos)
            dataSource.apply(snapshot, animatingDifferences: true)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    convenience init() {
        self.init(frame: .zero)
        setupLayout()
        setupDataSource()
    }

    private func setupLayout() {
        backgroundColor = .white
        addSubview(headerStackView)
        headerStackView.addArrangedSubview(imagesView)
        headerStackView.addArrangedSubview(userInfoView)
        addSubview(photoAlbumsTitle)
        addSubview(segmentedControl)
        addSubview(photoAlbumsCollectionView)

        NSLayoutConstraint.activate([
            headerStackView.leftAnchor.constraint(equalTo: leftAnchor),
            headerStackView.rightAnchor.constraint(equalTo: rightAnchor),
            headerStackView.topAnchor.constraint(equalTo: topAnchor),
            headerStackView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.45),

            imagesView.leftAnchor.constraint(equalTo: headerStackView.leftAnchor),
            imagesView.topAnchor.constraint(equalTo: headerStackView.topAnchor),
            imagesView.rightAnchor.constraint(equalTo: headerStackView.rightAnchor),
            imagesView.heightAnchor.constraint(equalTo: headerStackView.heightAnchor, multiplier: 0.75),

            navigationImageView.leftAnchor.constraint(equalTo: imagesView.leftAnchor),
            navigationImageView.topAnchor.constraint(equalTo: imagesView.topAnchor),
            navigationImageView.rightAnchor.constraint(equalTo: imagesView.rightAnchor),
            navigationImageView.heightAnchor.constraint(equalTo: imagesView.heightAnchor, multiplier: 0.8),

            profileView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4),
            profileView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4),
            profileView.centerXAnchor.constraint(equalTo: centerXAnchor),
            profileView.bottomAnchor.constraint(equalTo: imagesView.bottomAnchor),

            profileImageView.topAnchor.constraint(equalTo: profileView.topAnchor, constant: 5),
            profileImageView.leftAnchor.constraint(equalTo: profileView.leftAnchor, constant: 5),
            profileImageView.rightAnchor.constraint(equalTo: profileView.rightAnchor, constant: -5),
            profileImageView.bottomAnchor.constraint(equalTo: profileView.bottomAnchor, constant: -5),

            userNameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 30),
            userNameLabel.topAnchor.constraint(equalTo: userInfoView.topAnchor, constant: 10),

            bioTextView.leftAnchor.constraint(equalTo: userNameLabel.leftAnchor),
            bioTextView.bottomAnchor.constraint(equalTo: userInfoView.bottomAnchor),
            bioTextView.rightAnchor.constraint(equalTo: rightAnchor),
            bioTextView.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor),

            cameraIconImage.rightAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: -5),
            cameraIconImage.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: -5),

            userInfoView.leftAnchor.constraint(equalTo: headerStackView.leftAnchor),

            photoAlbumsTitle.centerXAnchor.constraint(equalTo: centerXAnchor),
            photoAlbumsTitle.topAnchor.constraint(equalTo: headerStackView.bottomAnchor, constant: Constants.paddingNavigationButtons),

            segmentedControl.topAnchor.constraint(equalTo: photoAlbumsTitle.bottomAnchor, constant: 10),
            segmentedControl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14),
            segmentedControl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14),

            photoAlbumsCollectionView.leftAnchor.constraint(equalTo: leftAnchor, constant: Constants.paddingPhotoAlbumsCollectionView),
            photoAlbumsCollectionView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 10),
            photoAlbumsCollectionView.rightAnchor.constraint(equalTo: rightAnchor, constant: -Constants.paddingPhotoAlbumsCollectionView),
            photoAlbumsCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

extension ProfileView: ProfileViewProtocol {
    
    var view: UIView {
        return self
    }
    
    func updateProfileImageView(with url: URL) {
        profileImageView.downloadImage(from: url) {
            self.profileImageView.image = UIImage(named: PhotoType.profile.defaultImage)
        }
    }
    
    func updateCoverImageView(with url: URL) {
        navigationImageView.downloadImage(from: url) {
            self.navigationImageView.image = UIImage(named: PhotoType.cover.defaultImage)
        }
    }
    
    func updateCoverImageView(with image: String) {
        navigationImageView.image = UIImage(named: image)
    }
    
    func updateProfileImageView(with image: String) {
        profileImageView.image = UIImage(named: image)
    }

    func updateUserProfileData(with user: User) {
        userNameLabel.text = user.getUserFirsNameAndLastName()
        guard let aboutText = user.about else {
            bioTextView.delegate = self
            bioTextView.attributedText = composeUserEmailAttributedText(email: user.email)
            bioTextView.font = .robotoRegular(size: 14)
            return
        }

        bioTextView.text = aboutText
    }

    private func composeUserEmailAttributedText(email: String) -> NSMutableAttributedString {
        let text = "Email: \(email)"
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.link, value: "mailto:\(email)", range: attributedString.mutableString.range(of: email))
        return attributedString
    }

    func setupNavigationButtons(navigationItem: UINavigationItem) {
        navigationItem.leftBarButtonItem = addPostButton
        navigationItem.rightBarButtonItem = logOutButton

        delegate?.removeBackArrowFromBackButton()
        navigationItem.backBarButtonItem = backCrossSign
    }

    func updatePhotoAlbumsCollectionView(with data: PhotoAlbums) {
        for (index, album) in data.data.enumerated() {
            segmentedControl.insertSegment(withTitle: album.name, at: index, animated: false)
        }
        segmentedControl.selectedSegmentIndex = 0
        photos = data.data[Constants.photosIndex].photos.data
        coverPhotos = data.data[Constants.coverPhotosIndex].photos.data
        profilePictures = data.data[Constants.profilePicturesIndex].photos.data

        updateDataSource()
    }

}

extension ProfileView: ProfileViewActionProtocol {
    func didTapAppPostButton() {
        delegate?.addPost()
    }
    
    func didTapLogOutButton() {
        delegate?.logOut()
    }
}

extension ProfileView: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        UIApplication.shared.open(URL)
        return true
    }
}

extension ProfileView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (frame.size.width - Constants.tabCount * Constants.paddingPhotoAlbumsCollectionView) / Constants.tabCount
        return CGSize(width: size, height: size)
    }
}

private extension ProfileView {
    struct Constants {
        static let paddingNavigationButtons: CGFloat = 20
        static let paddingPhotoAlbumsCollectionView: CGFloat = 6
        static let photosIndex: Int = 0
        static let coverPhotosIndex: Int = 1
        static let profilePicturesIndex: Int = 2
        static let tabCount: CGFloat = 3
    }
}
