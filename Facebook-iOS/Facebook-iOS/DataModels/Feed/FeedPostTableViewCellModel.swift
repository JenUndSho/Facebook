//
//  FeedPostTableViewCellModel.swift
//  Facebook-iOS
//
//  Created by Evhenii Shovkovyi on 19.02.2024.
//

import Foundation

struct FeedPostTableViewCellModel {
    let uuid = UUID()

    let profileUrl: URL
    let firstAndLastName: String
    let date: Date
    let message: String?
    let images: [Image]?
    let title: String
}

extension FeedPostTableViewCellModel: Equatable {
    static func == (left: FeedPostTableViewCellModel, right: FeedPostTableViewCellModel) -> Bool {
        return left.uuid == right.uuid
    }
}

extension FeedPostTableViewCellModel: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}

extension FeedPostTableViewCellModel {
    public static func parseFeedsToFeedPostsArray(feeds: Feeds, user: User, profileUrl: URL) -> [FeedPostTableViewCellModel] {

        var feedPosts: [FeedPostTableViewCellModel] = []
        guard !feeds.data.isEmpty else { return feedPosts }

        for index in 0...(feeds.data.count - 1) {
            let currentFeed = feeds.data[index]
            // add logic for gathering all images for this post
            let model = FeedPostTableViewCellModel(profileUrl: profileUrl,
                                                   firstAndLastName: user.getUserFirsNameAndLastName(),
                                                   date: currentFeed.createdTime,
                                                   message: currentFeed.message,
                                                   images: currentFeed.getImages(),
                                                   title: currentFeed.getTitle())
            feedPosts.append(model)
        }
        return feedPosts
    }
}
