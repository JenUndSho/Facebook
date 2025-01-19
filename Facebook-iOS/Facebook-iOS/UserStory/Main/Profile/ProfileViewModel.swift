//
//  ProfileViewModel.swift
//  Facebook-iOS
//
//  Created by Evhenii Shovkovyi on 18.10.2023.
//

import FBSDKLoginKit
import Foundation

protocol ProfileViewModelDelegate: AnyObject {
    func showAlert(with text: String)
    func setUserProfileData(with user: User)
    func setUserCoverPhoto(with url: URL)
    func setUserProfilePhoto(with url: URL)
    func setUserCoverPhoto(with image: String)
    func setUserProfilePhoto(with image: String)
    func finishProfileCoordinator()
    func hideProgress()
    func setPhotoAlbumsData(with data: PhotoAlbums)
}

protocol ProfileViewModelProtocol {
    func fetchUserData()
    func fetchUserPhoto(for type: PhotoType, from user: User)
    func logOutFacebook()
    func fetchPhotoAlbumsData()
}

class ProfileViewModel: ProfileViewModelProtocol {

    weak var delegate: ProfileViewModelDelegate?
    private var profileNetworkService = ProfileNetworkService()
    private var facebookAuthService = FacebookAuthService()
    private var keychainService = KeychainService(account: KeychainConstants.facebookUser,
                                          service: KeychainConstants.facebookService)
    private var albumsNetworkService = AlbumNetworkService()

    func fetchUserData() {
        print("fetchUserData Request")
        profileNetworkService.getUserProfileData { result in
            switch result {
            case .failure(let error):
                self.delegate?.setUserCoverPhoto(with: PhotoType.cover.defaultImage)
                self.delegate?.setUserProfilePhoto(with: PhotoType.profile.defaultImage)
                self.delegate?.showAlert(with: error.description)
            case .success(let user):
                self.delegate?.setUserProfileData(with: user)
            }
            self.delegate?.hideProgress()
        }
    }
    
    func fetchUserPhoto(for type: PhotoType, from user: User) {
        print("fetchUserPhoto Request")
        profileNetworkService.getUserImage(for: type, from: user) { result in
            switch result {
            case .failure:
                switch type {
                case .cover:
                    self.delegate?.setUserCoverPhoto(with: PhotoType.cover.defaultImage)
                case .profile:
                    self.delegate?.setUserProfilePhoto(with: PhotoType.profile.defaultImage)
                }
            case .success(let photo):
                switch type {
                case .cover:
                    self.delegate?.setUserCoverPhoto(with: photo.picture.data.url)
                case .profile:
                    self.delegate?.setUserProfilePhoto(with: photo.picture.data.url)
                }
            }
        }
    }

    func logOutFacebook() {
        print("logOutFacebook Request")
        facebookAuthService.signOut { result in
            switch result {
            case .failure(let error):
                self.delegate?.showAlert(with: error.description)
            case .success:
                do {
                    try self.keychainService.deleteToken()
                } catch {
                    self.delegate?.showAlert(with: KeychainConstants.unableToDelete.rawValue)
                }
                self.delegate?.finishProfileCoordinator()
            }
        }
    }

    func fetchPhotoAlbumsData() {
        print("fetchPhotoAlbumsData Request")
        albumsNetworkService.getAlbumData { result in
            switch result {
            case .failure(let error):
                self.delegate?.showAlert(with: error.description)
            case .success(let albumsData):
                self.delegate?.setPhotoAlbumsData(with: albumsData)
            }
        }
    }
}
