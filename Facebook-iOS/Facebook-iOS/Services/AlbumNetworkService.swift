//
//  AlbumNetworkService.swift
//  Facebook-iOS
//
//  Created by Evhenii Shovkovyi on 02.05.2024.
//

import FBSDKCoreKit
import Foundation

protocol AlbumNetworkServiceProtocol {
    func getAlbumData(_ completion: @escaping (Result<PhotoAlbums, FacebookNetworkError>) -> Void)
}

class AlbumNetworkService: AlbumNetworkServiceProtocol {

    func getAlbumData(_ completion: @escaping (Result<PhotoAlbums, FacebookNetworkError>) -> Void) {
        let request = GraphRequest(graphPath: "me/albums", parameters: ["fields": "id, count, name, photos{picture,id}"])
        NetworkServiceHelper.executeGraphRequest(type: PhotoAlbums.self, request: request, completion)
    }

}
