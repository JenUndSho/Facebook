//
//  FeedViewModel.swift
//  Facebook-iOS
//
//  Created by Evhenii Shovkovyi on 18.10.2023.
//

import Foundation

protocol FeedViewModelDelegate: AnyObject {
    func showAlert(with text: String)
    func hideLoadingIndicatorAfterFetchingFeeds()
    func setFeedsData(with feeds: Feeds)
    func setUserData(with user: User)
    func setUserProfilePhoto(with image: URL)

    func setAllFeedsData(feeds: Feeds, user: User, imageUrl: URL)
}

protocol FeedViewModelProtocol {
    func fetchFeeds()
    func fetchUserData()
    func fetchUserPhoto(from user: User)
    func fetchFeeds(with url: URL)

    func fetchFeedsData()
}

class FeedViewModel: FeedViewModelProtocol {
    private let dispatchGroup = DispatchGroup()

    weak var delegate: FeedViewModelDelegate?
    private var feedsNetworkService = FeedNetworkService()
    private var profileNetworkService = ProfileNetworkService()

    private var feeds: Feeds?
    private var user: User?
    private var imageUrl: URL?

    func fetchFeeds() {
        print("fetchFeeds Request")
        dispatchGroup.enter()

        feedsNetworkService.getFeedData { result in
            switch result {
            case .failure(let error):
                self.delegate?.hideLoadingIndicatorAfterFetchingFeeds()
                self.delegate?.showAlert(with: error.description)
            case .success(let feeds):
                self.feeds = feeds

                self.dispatchGroup.leave()
            }
        }
    }

    func fetchFeeds(with url: URL) {
        print("fetchFeedsWithURL Request")
        guard !feedsNetworkService.isPaginating else { return }

        feedsNetworkService.getFeedData(nextFeedsUrl: url) { result in
            switch result {
            case .failure(let error):
                self.delegate?.hideLoadingIndicatorAfterFetchingFeeds()
                self.delegate?.showAlert(with: error.description)
            case .success(let feeds):
                self.delegate?.setFeedsData(with: feeds)
            }
        }
    }

    func fetchUserData() {
        print("fetchUserData Request")
        dispatchGroup.enter()

        profileNetworkService.getUserProfileData { result in
            switch result {
            case .failure(let error):
                self.delegate?.hideLoadingIndicatorAfterFetchingFeeds()
                self.delegate?.showAlert(with: error.description)
            case .success(let user):
                self.user = user
                self.dispatchGroup.leave()

                self.fetchUserPhoto(from: user)
            }
        }
    }

    func fetchUserPhoto(from user: User) {
        print("fetchUserPhoto Request")
        dispatchGroup.enter()

        profileNetworkService.getUserImage(for: PhotoType.profile, from: user) { result in
            switch result {
            case .failure:
                self.delegate?.hideLoadingIndicatorAfterFetchingFeeds()
                return
            case .success(let photo):
                self.imageUrl = photo.picture.data.url

                self.dispatchGroup.leave()
            }
        }
    }

    func fetchFeedsData() {
        self.fetchFeeds()
        if user == nil, imageUrl == nil {
            self.fetchUserData()
        }

        dispatchGroup.notify(queue: .main) {
            if let user = self.user, let feeds = self.feeds, let imageUrl = self.imageUrl {
                self.delegate?.setAllFeedsData(feeds: feeds, user: user, imageUrl: imageUrl)

                self.feeds = nil
            }
        }
    }
}
