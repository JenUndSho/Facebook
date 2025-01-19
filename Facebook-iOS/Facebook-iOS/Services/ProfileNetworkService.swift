//
//  ProfileNetworkService.swift
//  Facebook-iOS
//
//  Created by Evhenii Shovkovyi on 25.12.2023.
//

import FBSDKCoreKit
import Foundation

protocol ProfileNetworkServiceProtocol {
    func getUserProfileData(_ completion: @escaping (Result<User, FacebookNetworkError>) -> Void)
    func getUserImage(for type: PhotoType, from user: User, _ completion: @escaping (Result<Photo, FacebookNetworkError>) -> Void)
}

enum FacebookNetworkError: Error, LocalizedError {
    case generalNetwork
    case unknown
    case offline

    var description: String {
        switch self {
        case .generalNetwork:
            return "We faced a problem while fetching your data. Please try again later."
        case .unknown:
            return "Unkown error."
        case .offline:
            return "The Internet connection appears to be offline."
        }
    }
}

class ProfileNetworkService: ProfileNetworkServiceProtocol {
    
    func getUserProfileData(_ completion: @escaping (Result<User, FacebookNetworkError>) -> Void) {
        guard AccessToken.current != nil else {
            completion(.failure(.unknown))
            return
        }

        let request = GraphRequest(graphPath: "me", parameters: ["fields": "id, first_name, picture.type(large), last_name, about, albums, email"])
        NetworkServiceHelper.executeGraphRequest(type: User.self, request: request, completion)
    }
    
    func getUserImage(for type: PhotoType, from user: User, _ completion: @escaping (Result<Photo, FacebookNetworkError>) -> Void) {
        guard AccessToken.current != nil else {
            completion(.failure(.unknown))
            return
        }
        let grapthPathDirectory: String
        switch type {
        case .cover:
            grapthPathDirectory = user.albums?.data.filter {
                $0.name == Constants.coverPhotosAlbum
            }.first?.id ?? ""
        case .profile:
            grapthPathDirectory = user.albums?.data.filter {
                $0.name == Constants.profilePhotosAlbum
            }.first?.id ?? ""
        }

        let request = GraphRequest(graphPath: "\(grapthPathDirectory)", parameters: ["fields": "picture"])
        NetworkServiceHelper.executeGraphRequest(type: Photo.self, request: request, completion)
    }

    private struct Constants {
        static let coverPhotosAlbum = "Cover photos"
        static let profilePhotosAlbum = "Profile pictures"
    }
}
