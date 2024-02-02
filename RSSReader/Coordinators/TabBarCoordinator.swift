//
//  TabBarCoordinator.swift
//  RSSReader
//
//  Created by Fabijan Mihanović on 02.02.2024..
//

import UIKit
import Combine

class TabBarCoordinator: CoordinatorProtocol {

    var dependencies: AppDependency
    var childCoordinators: [CoordinatorProtocol] = []
    var navigationController: NavigationViewController

    weak var parentCoordinator: BaseCoordinator?

    var tabBarController: UITabBarController!
    var cancellables = Set<AnyCancellable>()

    init(navigationController: NavigationViewController, dependencies: AppDependency) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }

    func start() {
        let pages: [TabBarPage] = TabBarPage.allCases

        let controllers: [UINavigationController] = pages.map { getTabController($0) }
        tabBarController = MainTabBarViewController()
        tabBarController.setViewControllers(controllers, animated: false)
        tabBarController.selectedIndex = TabBarPage.home.pageOrder

        navigationController.setViewControllers([tabBarController], animated: false)
        navigationController.setNavigationBarHidden(true, animated: false)
    }

    private func getTabController(_ page: TabBarPage) -> UINavigationController {
        let navController = NavigationViewController()
        navController.tabBarItem = UITabBarItem(title: page.title, image: page.icon, tag: page.pageOrder)

        switch page {
        case .home:
            let coordinator = HomeCoordinator(dependencies: dependencies, navigationController: navController)
            coordinator.parentCoordinator = self
            childCoordinators.append(coordinator)
            coordinator.start()
        case .search:
            let coordinator = SearchCoordinator(dependencies: dependencies, navigationController: navController)
            coordinator.parentCoordinator = self
            childCoordinators.append(coordinator)
            coordinator.start()
        case .more:
            let coordinator = MoreCoordinator(dependencies: dependencies, navigationController: navController)
            coordinator.parentCoordinator = self
            childCoordinators.append(coordinator)
            coordinator.start()
        }

        return navController
    }


}
