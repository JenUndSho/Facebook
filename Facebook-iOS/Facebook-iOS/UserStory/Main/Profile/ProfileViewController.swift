//
//  ProfileViewController.swift
//  Facebook-iOS
//
//  Created by Evhenii Shovkovyi on 25.09.2023.
//

import UIKit
import UITextView_Placeholder

class ProfileViewController: BaseViewController {
    var didSendEventClosure: ((ProfileViewController.Event, User?) -> Void)?

    private var profileViewModel: ProfileViewModel?
    private var profileView: ProfileViewProtocol?
    public var user: User?
    
    override func loadView() {
        profileViewModel = ProfileViewModel()
        profileViewModel?.delegate = self
        
        profileView = ProfileView()
        profileView?.delegate = self
        view = profileView?.view

        setupLayout()
    }

    private func setupLayout() {
        profileView?.setupNavigationButtons(navigationItem: navigationItem)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        showProgress(NSLocalizedString("Loading", comment: ""))

        profileViewModel?.fetchUserData()
        profileViewModel?.fetchPhotoAlbumsData()
    }

}

extension ProfileViewController: ProfileViewModelDelegate {
    
    func setUserProfileData(with user: User) {
        profileView?.updateUserProfileData(with: user)
        profileViewModel?.fetchUserPhoto(for: .cover, from: user)
        profileViewModel?.fetchUserPhoto(for: .profile, from: user)

        self.user = user
    }

    func setUserCoverPhoto(with url: URL) {
        profileView?.updateCoverImageView(with: url)
    }

    func setUserProfilePhoto(with url: URL) {
        profileView?.updateProfileImageView(with: url)
        self.user?.picture.data.url = url
    }

    func setUserCoverPhoto(with image: String) {
        profileView?.updateCoverImageView(with: image)
    }

    func setUserProfilePhoto(with image: String) {
        profileView?.updateProfileImageView(with: image)
    }

    func finishProfileCoordinator() {
        hideProgress()
        didSendEventClosure?(.closeProfilePage, nil)
    }

    func setPhotoAlbumsData(with data: PhotoAlbums) {
        profileView?.updatePhotoAlbumsCollectionView(with: data)
    }
}

extension ProfileViewController: ProfileViewDelegate {
    func removeBackArrowFromBackButton() {
        let backImage = UIImage()
        self.navigationController?.navigationBar.backIndicatorImage = backImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
    }
    
    @objc
    func addPost() {
        didSendEventClosure?(.openCreatePostPage, user)
    }

    @objc
    func logOut() {
        showProgress(NSLocalizedString("Loading", comment: ""))
        profileViewModel?.logOutFacebook()
    }
    
}

extension ProfileViewController {
    enum Event {
        case closeProfilePage
        case openCreatePostPage
    }
}
