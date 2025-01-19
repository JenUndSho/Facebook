//
//  ProfileCoordinator.swift
//  Facebook-iOS
//
//  Created by Evhenii Shovkovyi on 18.10.2023.
//

import Foundation
import UIKit

protocol ProfileCoordinatorProtocol: Coordinator {
    func showProfileViewController()
    func showCreatePostFlow(user: User?)
}

class ProfileCoordinator: TabBarPageInfoProtocol {

    let pageTitle = "Profile"
    let pageImage = UIImage(named: "profile_plain") ?? UIImage()

    var navigationController: UINavigationController

    weak var finishDelegate: CoordinatorDidFinishDelegate?

    var childCoordinators: [Coordinator] = []

    var type: CoordinatorType {
        .profile
    }

    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        showProfileViewController()
    }

}

extension ProfileCoordinator: ProfileCoordinatorProtocol {
    func showProfileViewController() {
        let profileVc = ProfileViewController()
        profileVc.didSendEventClosure = { [weak self] event, user in
            switch event {
            case .closeProfilePage:
                self?.finish()
            case .openCreatePostPage:
                self?.showCreatePostFlow(user: user)
            }
        }
        navigationController.pushViewController(profileVc, animated: true)
    }

    func showCreatePostFlow(user: User?) {
        let createPostCoordinator: CreatePostCoordinator = .init(navigationController)
        createPostCoordinator.start(user: user)
        createPostCoordinator.finishDelegate = self
        childCoordinators.append(createPostCoordinator)
    }
}

extension ProfileCoordinator: CoordinatorDidFinishDelegate {
    func coordinatorDidFinish(childCoordintor: Coordinator) {
        navigationController.popViewController(animated: true)
    }
}
