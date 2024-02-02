//
//  HomeCoordinator.swift
//  RSSReader
//
//  Created by Fabijan Mihanović on 02.02.2024..
//

import Foundation
import Combine

class HomeCoordinator: CoordinatorProtocol {

    var dependencies: AppDependency
    var childCoordinators: [CoordinatorProtocol] = []
    var navigationController: NavigationViewController

    weak var parentCoordinator: TabBarCoordinator?

    init(dependencies: AppDependency, navigationController: NavigationViewController) {
        self.dependencies = dependencies
        self.navigationController = navigationController
    }

    func start() {
        let home = UIViewControllerFactory.createHomeParchmentViewController()
        navigationController.setViewControllers([home], animated: false)
    }
}
