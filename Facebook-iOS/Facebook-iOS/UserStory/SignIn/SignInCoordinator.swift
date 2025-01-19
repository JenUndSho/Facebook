//
//  SignInCoordinator.swift
//  Facebook-iOS
//
//  Created by Evhenii Shovkovyi on 24.09.2023.
//

import Foundation
import UIKit

protocol SignInCoordinatorProtocol: Coordinator {
    func showSignInViewController()
}

class SignInCoordinator: SignInCoordinatorProtocol {
    var navigationController: UINavigationController
    
    weak var finishDelegate: CoordinatorDidFinishDelegate?
        
    var childCoordinators: [Coordinator] = []
    
    var type: CoordinatorType {
        .signIn
    }
    
    func start() {
        showSignInViewController()
    }
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func showSignInViewController() {
        let signInVC = SignInViewController()
        signInVC.didSendEventClosure = { [weak self] event in
            switch event {
            case .closeSignInPage:
                self?.finish()
            }
        }
        navigationController.pushViewController(signInVC, animated: true)
    }
    
}
