//
//  PhotoAlbums.swift
//  Facebook-iOS
//
//  Created by Evhenii Shovkovyi on 02.05.2024.
//

import Foundation

// MARK: - PhotoAlbums
struct PhotoAlbums: Codable, DataModelProtocol {
    let data: [AlbumData]

    init(dictionary: NSDictionary) throws {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        self = try decoder.decode(PhotoAlbums.self, from: JSONSerialization.data(withJSONObject: dictionary))
    }
}

// MARK: - AlbumData
struct AlbumData: Codable {
    let id: String
    let count: Int
    let name: String
    let photos: AlbumPhotos
}

// MARK: - AlbumPhotos
struct AlbumPhotos: Codable {
    let data: [PhotoData]
    let paging: PhotosPaging
}

// MARK: - PhotoData
struct PhotoData: Codable {
    let picture: URL
    let id: String
}

extension PhotoData: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - PhotosPaging
struct PhotosPaging: Codable {
    let cursors: Cursors
    let next: String?
}

// MARK: - Cursors
struct Cursors: Codable {
    let before: String
    let after: String
}
