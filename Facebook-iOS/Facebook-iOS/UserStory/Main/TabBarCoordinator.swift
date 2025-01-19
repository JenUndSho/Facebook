//
//  TabBarCoordinator.swift
//  Facebook-iOS
//
//  Created by Evhenii Shovkovyi on 24.09.2023.
//

import Foundation
import UIKit

protocol TabBarPageInfoProtocol {
    var pageTitle: String { get }
    var pageImage: UIImage { get }
}

enum TabBarPage {
    case profile, feed
    
    init?(index: Int) {
        switch index {
        case 0:
            self = .feed
        case 1:
            self = .profile
        default:
            return nil
        }
    }
    
    func getPageIndex() -> Int {
        switch self {
        case .profile:
            return 1
        case .feed:
            return 0
        }
    }

}

protocol TabBarCoordinatorProtocol: Coordinator {
    var tabBarController: UITabBarController { get set }
    func selectPage(_ page: TabBarPage)
    func setSelectedIndex(_ index: Int)
    func currentPage() -> TabBarPage?
}

class TabBarCoordinator: NSObject, TabBarCoordinatorProtocol {
    
    var tabBarController: UITabBarController
    
    var navigationController: UINavigationController
    
    weak var finishDelegate: CoordinatorDidFinishDelegate?
    
    var childCoordinators: [Coordinator] = []
    
    var type: CoordinatorType {
        .tab
    }
    
    func start() {
        let pages: [TabBarPage] = [.feed, .profile]
            .sorted(by: { $0.getPageIndex() < $1.getPageIndex() })
        
        let controllers: [UINavigationController] = pages.map({ getTabController($0) })
        
        prepareTabController(withTabBarConrollers: controllers)
        
    }
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.tabBarController = UITabBarController()
    }
    
    func selectPage(_ page: TabBarPage) {
        tabBarController.selectedIndex = page.getPageIndex()
    }
    
    func setSelectedIndex(_ index: Int) {
        guard let page = TabBarPage(index: index) else { return }
        
        tabBarController.selectedIndex = page.getPageIndex()
    }
    
    func currentPage() -> TabBarPage? {
        TabBarPage(index: tabBarController.selectedIndex)
    }
    
    private func prepareTabController(withTabBarConrollers controllers: [UIViewController]) {
        tabBarController.delegate = self
        tabBarController.setViewControllers(controllers, animated: true)
        tabBarController.selectedIndex = TabBarPage.feed.getPageIndex()
        tabBarController.tabBar.backgroundColor = .white
        
        navigationController.viewControllers = [tabBarController]
    }
    
    private func getTabController(_ page: TabBarPage) -> UINavigationController {
        let navController = UINavigationController()
        let currentTabCoordinator: Coordinator & TabBarPageInfoProtocol

        switch page {
        case .feed:
            let feedCoordinator: FeedCoordinator = .init(navController)
            feedCoordinator.start()
            feedCoordinator.finishDelegate = self
            childCoordinators.append(feedCoordinator)
            currentTabCoordinator = feedCoordinator
        case .profile:
            let profileCoordinator: ProfileCoordinator = .init(navController)
            profileCoordinator.start()
            profileCoordinator.finishDelegate = self
            childCoordinators.append(profileCoordinator)
            currentTabCoordinator = profileCoordinator
        }

        navController.tabBarItem = UITabBarItem(title: currentTabCoordinator.pageTitle,
                                                image: currentTabCoordinator.pageImage,
                                                tag: page.getPageIndex())
        navController.setToolbarHidden(false, animated: false)
        return navController
        
    }
}

extension TabBarCoordinator: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
    }
}

extension TabBarCoordinator: CoordinatorDidFinishDelegate {
    func coordinatorDidFinish(childCoordintor: Coordinator) {
        finish()
    }
}
