//
//  User.swift
//  Facebook-iOS
//
//  Created by Evhenii Shovkovyi on 21.12.2023.
//

import Foundation

struct User: Codable, DataModelProtocol {
    let id: String
    let firstName: String
    let lastName: String
    let email: String
    let about: String?
    var picture: Picture
    let albums: Album?

    struct Picture: Codable {
        var data: DataClass
    }

    struct DataClass: Codable {
        var url: URL
    }
    
    struct Album: Codable {
        let data: [AlbumDataClass]
    }
    
    struct AlbumDataClass: Codable {
        let createdTime: Date
        let name: String
        let id: String
    }
    
    init(dictionary: NSDictionary) throws {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        self = try decoder.decode(User.self, from: JSONSerialization.data(withJSONObject: dictionary))
    }

    public func getUserFirsNameAndLastName() -> String {
        return "\(firstName) \(lastName)"
    }

    public mutating func setPictureUrl(with url: URL) {
        self.picture.data.url = url
    }
}

extension User: Hashable {
    static func == (left: User, right: User) -> Bool {
        left.id == right.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(firstName)
        hasher.combine(lastName)
        hasher.combine(about)
        hasher.combine(picture.data.url)
        hasher.combine(email)
      }
}

extension User {
    init(firstName: String, lastName: String) {
        self.id = UUID().uuidString
        self.firstName = firstName
        self.lastName = lastName
        self.email = "test@mail.com"
        self.about = nil
        // swiftlint:disable:next force_unwrapping
        self.picture = Picture(data: DataClass(url: URL(string: "https://www.google.com/")!))
        self.albums = nil
    }
}
