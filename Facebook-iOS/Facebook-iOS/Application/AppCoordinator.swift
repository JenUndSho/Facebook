//
//  AppCoordinator.swift
//  Facebook-iOS
//
//  Created by Evhenii Shovkovyi on 16.08.2023.
//

import Foundation
import UIKit

protocol AppCoordinatorProtocol: Coordinator {
    func showSignInFlow()
    func showMainFlow()
}

class AppCoordinator: AppCoordinatorProtocol {
    
    var navigationController: UINavigationController
    
    weak var finishDelegate: CoordinatorDidFinishDelegate?
    
    var childCoordinators = [Coordinator]()
    
    private var isUserLoggedIn: Bool
    
    var type: CoordinatorType {
        .app
    }
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.isUserLoggedIn = false
        navigationController.setToolbarHidden(true, animated: false)
    }
    
    init(_ navigationController: UINavigationController, isUserLoggedIn: Bool = false) {
        self.navigationController = navigationController
        self.isUserLoggedIn = isUserLoggedIn
        navigationController.setToolbarHidden(true, animated: false)
    }
    
    func start() {
        if isUserLoggedIn {
            showMainFlow()
        } else {
            showSignInFlow()
        }
        
    }
    
    func showSignInFlow() {
        let signInCoordinator: SignInCoordinator = .init(navigationController)
        signInCoordinator.finishDelegate = self
        signInCoordinator.start()
        childCoordinators.append(signInCoordinator)
    }
    
    func showMainFlow() {
        let tabBarCoordinator: TabBarCoordinator = .init(navigationController)
        tabBarCoordinator.finishDelegate = self
        tabBarCoordinator.start()
        childCoordinators.append(tabBarCoordinator)
    }
    
}

extension AppCoordinator: CoordinatorDidFinishDelegate {
    func coordinatorDidFinish(childCoordintor: Coordinator) {
        childCoordinators = childCoordinators.filter({ $0.type != childCoordintor.type })
        
        switch childCoordintor.type {
        case .signIn:
            navigationController.viewControllers.removeAll()
            showMainFlow()
        case .tab:
            navigationController.viewControllers.removeAll()
            showSignInFlow()
        default:
            break
        }
        
    }
}
