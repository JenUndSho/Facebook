//
//  Coordinator.swift
//  Facebook-iOS
//
//  Created by Evhenii Shovkovyi on 16.08.2023.
//

import Foundation
import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    var finishDelegate: CoordinatorDidFinishDelegate? { get set }
    var childCoordinators: [Coordinator] { get set }
    var type: CoordinatorType { get }
    func start()
    func finish()
    init (_ navigationController: UINavigationController)
}

extension Coordinator {
    func finish() {
        childCoordinators.removeAll()
        finishDelegate?.coordinatorDidFinish(childCoordintor: self)
    }
}

protocol CoordinatorDidFinishDelegate: AnyObject {
    func coordinatorDidFinish(childCoordintor: Coordinator)
}

enum CoordinatorType {
    case app
    case signIn
    case tab
    case feed
    case profile
    case createPost
}
