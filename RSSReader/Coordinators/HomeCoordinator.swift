//
//  HomeCoordinator.swift
//  RSSReader
//
//  Created by Fabijan Mihanović on 02.02.2024..
//

import UIKit
import Combine

class HomeCoordinator: CoordinatorProtocol, CSafariViewProtocol, CFeedActionsProtocol {

    var dependencies: AppDependency
    var childCoordinators: [CoordinatorProtocol] = []
    var navigationController: NavigationViewController

    weak var parentCoordinator: TabBarCoordinator?

    init(dependencies: AppDependency, navigationController: NavigationViewController) {
        self.dependencies = dependencies
        self.navigationController = navigationController
    }

    func start() {
        let home = UIViewControllerFactory.createHomeParchmentViewController(coordinator: self)
        navigationController.setViewControllers([home], animated: false)
    }

    func addPublisher() {
        let addRSS = UIViewControllerFactory.createAddRSSViewController(coordinator: self)
        navigationController.pushViewController(addRSS, animated: true)
    }
}
