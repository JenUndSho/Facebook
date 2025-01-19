//
//  CoverPhoto.swift
//  Facebook-iOS
//
//  Created by Evhenii Shovkovyi on 15.02.2024.
//

import Foundation

enum PhotoType {
    case cover
    case profile

    var defaultUrl: URL {
        switch self {
        case .cover:
            return URL.getUrl("https://png.pngtree.com/thumb_back/fh260/background/20230527/pngtree-nature-wallpapers-image_2683049.jpg")
        case .profile:
            return URL.getUrl("https://community.sailpoint.com/t5/image/serverpage/image-id/10533i1F90D9618A930108/image-size/large/is-moderation-mode/true?v=v2&px=999") 
        }
    }

    var defaultImage: String {
        switch self {
        case .cover:
            return "default_cover"
        case .profile:
            return "default_profile"
        }
    }
}

struct Photo: Codable, DataModelProtocol {

    let picture: Picture
    
    struct Picture: Codable {
        let data: DataClass
    }

    struct DataClass: Codable {
        let url: URL
    }
    
    init(dictionary: NSDictionary) throws {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        self = try decoder.decode(Photo.self, from: JSONSerialization.data(withJSONObject: dictionary))
    }
}

extension Photo: Hashable {
    static func == (left: Photo, right: Photo) -> Bool {
        left.picture.data.url == right.picture.data.url
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(picture.data.url)
      }
}
