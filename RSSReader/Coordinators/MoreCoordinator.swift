//
//  MoreCoordinator.swift
//  RSSReader
//
//  Created by Fabijan Mihanović on 02.02.2024..
//

import UIKit

class MoreCoordinator: CoordinatorProtocol, CSafariViewProtocol, CFeedActionsProtocol {

    var dependencies: AppDependency
    var childCoordinators: [CoordinatorProtocol] = []
    var navigationController: NavigationViewController

    weak var parentCoordinator: TabBarCoordinator?

    init(dependencies: AppDependency, navigationController: NavigationViewController) {
        self.dependencies = dependencies
        self.navigationController = navigationController
    }

    func start() {
        let home = UIViewControllerFactory.createMoreViewController(coordinator: self)
        navigationController.setViewControllers([home], animated: false)
    }

    func history() {
        let history = UIViewControllerFactory.createHistoryViewController(coordinator: self)
        navigationController.pushViewController(history, animated: true)
    }
}

