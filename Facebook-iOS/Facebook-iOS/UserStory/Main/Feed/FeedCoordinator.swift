//
//  FeedCoordinator.swift
//  Facebook-iOS
//
//  Created by Evhenii Shovkovyi on 18.10.2023.
//

import Foundation
import UIKit

protocol FeedCoordinatorProtocol: Coordinator {
    func showFeedViewController()
}

class FeedCoordinator: TabBarPageInfoProtocol {

    let pageTitle = "Feed"
    let pageImage = UIImage(named: "feed_plain") ?? UIImage()

    var navigationController: UINavigationController

    weak var finishDelegate: CoordinatorDidFinishDelegate?

    var childCoordinators: [Coordinator] = []

    var type: CoordinatorType {
        .feed
    }

    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        showFeedViewController()
    }
}

extension FeedCoordinator: FeedCoordinatorProtocol {
    func showFeedViewController() {
        let feedVc = FeedViewController()
        navigationController.pushViewController(feedVc, animated: true)
    }
}

extension FeedCoordinator: CoordinatorDidFinishDelegate {
    func coordinatorDidFinish(childCoordintor: Coordinator) {
        // todo
    }
}
