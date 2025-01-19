//
//  FeedNetworkService.swift
//  Facebook-iOS
//
//  Created by Evhenii Shovkovyi on 24.01.2024.
//
import FBSDKCoreKit
import Foundation

protocol FeedNetworkServiceProtocol {
    func getFeedData(_ completion: @escaping (Result<Feeds, FacebookNetworkError>) -> Void)
    func getFeedData(nextFeedsUrl: URL, _ completion: @escaping (Result<Feeds, FacebookNetworkError>) -> Void)
}

class FeedNetworkService: FeedNetworkServiceProtocol {

    public var isPaginating = false

    public func getFeedData(_ completion: @escaping (Result<Feeds, FacebookNetworkError>) -> Void) {
        produceFeedRequest(path: "me/feed", completion)
    }

    public func getFeedData(nextFeedsUrl: URL, _ completion: @escaping (Result<Feeds, FacebookNetworkError>) -> Void) {
        produceFeedRequest(path: NetworkServiceHelper.removeGraphHostAndVersion(from: nextFeedsUrl), completion)
    }

    private func produceFeedRequest(path: String, _ completion: @escaping (Result<Feeds, FacebookNetworkError>) -> Void) {
        isPaginating = true

        let request = GraphRequest(graphPath: path, parameters: ["limit": "5", "fields": "message, created_time, attachments"])
        NetworkServiceHelper.executeGraphRequest(type: Feeds.self, request: request, completion)

        isPaginating = false
    }
}
