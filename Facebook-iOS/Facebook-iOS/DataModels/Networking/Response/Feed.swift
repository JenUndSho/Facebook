//
//  Feed.swift
//  Facebook-iOS
//
//  Created by Evhenii Shovkovyi on 24.01.2024.
//

import Foundation

// MARK: - Feeds
struct Feeds: Codable, DataModelProtocol {
    let data: [Feed]
    let paging: Paging?
    
    init (dictionary: NSDictionary) throws {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        self = try decoder.decode(Feeds.self, from: JSONSerialization.data(withJSONObject: dictionary))
    }
}

// MARK: - Feed
struct Feed: Codable {
    let createdTime: Date
    let attachments: Attachments?
    let id: String
    let message: String?

    public func getImages() -> [Image] {
        var images: [Image] = []
        guard let attachmentData = attachments?.data[0] else { return images }
        guard let media = attachmentData.media else { return images }

        images.append(media.image)

        guard let subAttachments = attachmentData.subattachments else { return images }
        // if subattahmnets are present - then firts item there is media.image
        images.remove(at: 0)
        subAttachments.data.forEach {
            images.append($0.media.image)
        }

        return images
    }

    public func getTitle() -> String {
        guard let attachmentData = attachments?.data[0] else { return "" }
        return attachmentData.title ?? ""
    }
}

// MARK: - Attachments
struct Attachments: Codable {
    let data: [Attachment]
}

// MARK: - AttachmentsDatum
struct Attachment: Codable {
    let media: Media?
    let target: Target?
    let title, type: String?
    let url: URL?
    let subattachments: Subattachments?
    let description: String?
}

// MARK: - Media
struct Media: Codable {
    let image: Image
}

// MARK: - Image
struct Image: Codable {
    let height: Int
    let src: URL
    let width: Int
}

extension Image: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(src)
    }
}

// MARK: - Subattachments
struct Subattachments: Codable {
    let data: [Subattachment]
}

// MARK: - SubattachmentsDatum
struct Subattachment: Codable {
    let media: Media
    let target: Target
    let type: String
    let url: String
}

// MARK: - Target
struct Target: Codable {
    let id: String?
    let url: String
}

// MARK: - Paging
struct Paging: Codable {
    let previous: URL?
    let next: URL?
}
