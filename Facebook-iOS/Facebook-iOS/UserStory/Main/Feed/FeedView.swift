//
//  FeedView.swift
//  Facebook-iOS
//
//  Created by Evhenii Shovkovyi on 22.02.2024.
//

import Foundation
import UIKit

protocol FeedViewProtocol {
    var delegate: FeedViewDelegate? { get set }
    var view: UIView { get }
    func setupBottomHeaderConstraint(equalToConstant: CGFloat)
    func addGradientToFacebookTextLabel()
    func setFeedsData(with feeds: Feeds)
    func setUserData(with user: User)
    func setUserProfilePhoto(with image: URL)
    func hideLoadingIndicatorAfterFetchingFeeds()

    func setLoadingSpinnerToTableView()
    func setNextFeedsUrl(with url: URL)
}

protocol FeedViewDelegate: AnyObject {
    func fetchFeeds(with url: URL)
    func fetchFeeds()
    func fetchUserData()
    func scrollViewDidScroll(tableView: UITableView, nextUrl: URL?, savedUrl: URL?, data: [FeedPostTableViewCellModel])

    func fetchFeedsData()
}

class FeedView: UIView {

    weak var delegate: FeedViewDelegate?
    private var nextFeedsUrl: URL?
    private var data: [FeedPostTableViewCellModel] = []

    enum Section {
        case main
    }

    private var feeds: Feeds? {
        didSet {
            updateDataSource()
        }
    }
    private var user: User? {
        didSet {
            updateDataSource()
        }
    }
    private var userProfileImageUrl: URL? {
        didSet {
            updateDataSource()
        }
    }

    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Loading Feed Posts...")
        refreshControl.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
        return refreshControl
    }()

    var dataSource: UITableViewDiffableDataSource<Section, FeedPostTableViewCellModel>!

    private lazy var tableView: UITableView = {
        let localTableView = UITableView()
        localTableView.dataSource = dataSource
        localTableView.refreshControl = refreshControl
        localTableView.backgroundColor = .link
        localTableView.contentInsetAdjustmentBehavior = .never
        localTableView.separatorInset = UIEdgeInsets.zero
        localTableView.translatesAutoresizingMaskIntoConstraints = false
        localTableView.register(FeedPostTableViewCell.self, forCellReuseIdentifier: FeedPostTableViewCell.reuseIdentifier)
        return localTableView
    }()

    private lazy var facebookTextLabel: UILabel = {
        let localLabel = UILabel()
        localLabel.translatesAutoresizingMaskIntoConstraints = false
        localLabel.text = "facebook"
        localLabel.font = .ralewayBold(size: 20)
        localLabel.textAlignment = .center
        return localLabel
    }()

    private lazy var navigationHeader: UIView = {
        let localView = UIView()
        localView.translatesAutoresizingMaskIntoConstraints = false
        localView.addSubview(facebookTextLabel)
        return localView
    }()

    private lazy var bottomHeader: UIView = {
        let localView = UIView()
        localView.translatesAutoresizingMaskIntoConstraints = false
        return localView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setupDataSource()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var lastCheck: Date?

    private func isRefreshEnabled() -> Bool {
        if let lastCheckDate = lastCheck, lastCheckDate.timeIntervalSinceNow * -1 < Constants.secondsToWait {
            refreshControl.endRefreshing()
            print("You can't make API call now. Wait a little bit...")
            return false
        }

        lastCheck = Date()
        return true
    }

    @objc
    private func refreshTableView() {
        guard isRefreshEnabled() else { return }

        data.removeAll()
        feeds = nil
        user = nil
        userProfileImageUrl = nil
        nextFeedsUrl = nil

        delegate?.fetchFeedsData()
        refreshControl.endRefreshing()
    }

    private func setupDataSource() {
        dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { tableView, indexPath, model -> UITableViewCell? in

            guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedPostTableViewCell.reuseIdentifier, for: indexPath) as? FeedPostTableViewCell else {
                return UITableViewCell()
            }
            
            cell.configurePostCell(with: model)

            return cell
        })
    }

    private func updateDataSource() {
        if let feeds = feeds,
           let user = user,
           let image = userProfileImageUrl {

            FeedPostTableViewCellModel.parseFeedsToFeedPostsArray(feeds: feeds, user: user, profileUrl: image).forEach { model in
                data.append(model)
            }
            hideLoadingIndicatorAfterFetchingFeeds()
            applySnapshot(items: data)
        }
    }

    func applySnapshot(items: [FeedPostTableViewCellModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, FeedPostTableViewCellModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    private func setupLayout() {
        tableView.delegate = self
        backgroundColor = .white
        addSubview(navigationHeader)
        addSubview(bottomHeader)
        addSubview(tableView)

        NSLayoutConstraint.activate([
            navigationHeader.leftAnchor.constraint(equalTo: leftAnchor),
            navigationHeader.topAnchor.constraint(equalTo: topAnchor),
            navigationHeader.rightAnchor.constraint(equalTo: rightAnchor),
            navigationHeader.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.1),

            bottomHeader.leftAnchor.constraint(equalTo: leftAnchor),
            bottomHeader.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomHeader.rightAnchor.constraint(equalTo: rightAnchor),

            tableView.leftAnchor.constraint(equalTo: leftAnchor),
            tableView.topAnchor.constraint(equalTo: navigationHeader.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomHeader.topAnchor),
            tableView.rightAnchor.constraint(equalTo: rightAnchor),

            facebookTextLabel.leftAnchor.constraint(equalTo: leftAnchor),
            facebookTextLabel.rightAnchor.constraint(equalTo: rightAnchor),
            facebookTextLabel.heightAnchor.constraint(equalTo: navigationHeader.heightAnchor, multiplier: 0.5),
            facebookTextLabel.bottomAnchor.constraint(equalTo: navigationHeader.bottomAnchor)
        ])
    }

    private func createSpinerFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        let indicator = UIActivityIndicatorView()
        indicator.color = .white
        indicator.center = footerView.center
        footerView.addSubview(indicator)
        indicator.startAnimating()

        return footerView
    }

    private struct Constants {
        static let secondsToWait = 60.0
    }
}

extension FeedView: FeedViewProtocol {
    func setLoadingSpinnerToTableView() {
        tableView.tableFooterView = createSpinerFooter()
    }
    
    func setNextFeedsUrl(with url: URL) {
        nextFeedsUrl = url
    }

    func hideLoadingIndicatorAfterFetchingFeeds() {
        DispatchQueue.main.async {
            self.tableView.tableFooterView = nil
        }
    }

    func setUserProfilePhoto(with image: URL) {
        self.userProfileImageUrl = image
    }

    func setFeedsData(with feeds: Feeds) {
        self.feeds = feeds
    }
    
    func setUserData(with user: User) {
        self.user = user
    }
    
    var view: UIView {
        return self
    }
    
    func setupBottomHeaderConstraint(equalToConstant constant: CGFloat) {
        NSLayoutConstraint.activate([
            bottomHeader.heightAnchor.constraint(equalToConstant: constant)
        ])
    }

    func addGradientToFacebookTextLabel() {
        layoutIfNeeded()
        let gradient = UIImage.gradientImage(bounds: facebookTextLabel.bounds,
                                             colors: [.blue, .white])
        facebookTextLabel.textColor = UIColor(patternImage: gradient)
        facebookTextLabel.addBorder(toSide: .bottom, withColor: .black, andThickness: 3.0)
    }
}

extension FeedView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.scrollViewDidScroll(tableView: tableView,
                                      nextUrl: self.feeds?.paging?.next,
                                      savedUrl: nextFeedsUrl,
                                      data: data)
    }
}
