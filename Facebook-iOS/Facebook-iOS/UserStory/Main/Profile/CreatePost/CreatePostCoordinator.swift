//
//  CreatePostCoordinator.swift
//  Facebook-iOS
//
//  Created by Evhenii Shovkovyi on 27.03.2024.
//

import Foundation
import UIKit

protocol CreatePostCoordinatorProtocol: Coordinator {
    func showCreatePostViewController(user: User?)
}

class CreatePostCoordinator {

    var navigationController: UINavigationController

    weak var finishDelegate: CoordinatorDidFinishDelegate?

    var childCoordinators: [Coordinator] = []

    var type: CoordinatorType {
        .createPost
    }

    func start() {
        start(user: nil)
    }

    func start(user: User?) {
        showCreatePostViewController(user: user)
    }

    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}

extension CreatePostCoordinator: CreatePostCoordinatorProtocol {
    func showCreatePostViewController(user: User?) {
        let createPostVC = CreatePostViewController(user: user)
        createPostVC.didSendEventClosure = { [weak self] event in
            switch event {
            case .closeCreatePostPage:
                self?.finish()
            }
        }
        navigationController.pushViewController(createPostVC, animated: true)
    }
    
}
