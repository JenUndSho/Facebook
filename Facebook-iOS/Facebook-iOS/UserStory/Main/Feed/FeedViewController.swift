//
//  FeedViewController.swift
//  Facebook-iOS
//
//  Created by Evhenii Shovkovyi on 25.09.2023.
//

import UIKit

class FeedViewController: BaseViewController {

    private var feedViewModel: FeedViewModel?
    private var feedView: FeedViewProtocol?
    public var feeds: Feeds?
    public var user: User?

    override func loadView() {
        feedViewModel = FeedViewModel()
        feedViewModel?.delegate = self

        feedView = FeedView()
        feedView?.delegate = self
        view = feedView?.view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        showProgress(NSLocalizedString("Loading", comment: ""))

        setupLayout()

        feedViewModel?.fetchFeedsData()

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        feedView?.addGradientToFacebookTextLabel()
    }

    private func setupLayout() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.setToolbarHidden(true, animated: false)
        feedView?.setupBottomHeaderConstraint(equalToConstant: tabBarHeight ?? 0.0)
    }

}

extension FeedViewController: FeedViewModelDelegate {
    func setAllFeedsData(feeds: Feeds, user: User, imageUrl: URL) {
        setFeedsData(with: feeds)
        setUserData(with: user)
        setUserProfilePhoto(with: imageUrl)
    }
    
    func hideLoadingIndicatorAfterFetchingFeeds() {
        feedView?.hideLoadingIndicatorAfterFetchingFeeds()
    }
    
    func setUserProfilePhoto(with image: URL) {
        feedView?.setUserProfilePhoto(with: image)
        hideProgress()
    }
    
    func setUserData(with user: User) {
        feedView?.setUserData(with: user)
    }
    
    func setFeedsData(with feeds: Feeds) {
        feedView?.setFeedsData(with: feeds)
    }
}

extension FeedViewController: FeedViewDelegate {
    func fetchFeedsData() {
        feedViewModel?.fetchFeedsData()
    }

    func scrollViewDidScroll(tableView: UITableView, nextUrl: URL?, savedUrl: URL?, data: [FeedPostTableViewCellModel]) {
        if tableView.contentOffset.y >= (tableView.contentSize.height - tableView.frame.size.height) {
            if let url = nextUrl, savedUrl != url, !data.isEmpty {
                feedView?.setLoadingSpinnerToTableView()
                feedView?.setNextFeedsUrl(with: url)
                feedViewModel?.fetchFeeds(with: url)
            }
        }
    }
    
    func fetchUserData() {
        feedViewModel?.fetchUserData()
    }
    
    func fetchFeeds(with url: URL) {
        feedViewModel?.fetchFeeds(with: url)
    }

    func fetchFeeds() {
        feedViewModel?.fetchFeeds()
    }
}
