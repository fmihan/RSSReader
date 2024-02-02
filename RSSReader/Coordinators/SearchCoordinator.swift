//
//  SearchCoordinator.swift
//  RSSReader
//
//  Created by Fabijan Mihanović on 02.02.2024..
//

import UIKit
import SafariServices

class SearchCoordinator: CoordinatorProtocol, CSafariViewProtocol, CFeedActionsProtocol {

    var dependencies: AppDependency
    var childCoordinators: [CoordinatorProtocol] = []
    var navigationController: NavigationViewController

    weak var parentCoordinator: TabBarCoordinator?

    init(dependencies: AppDependency, navigationController: NavigationViewController) {
        self.dependencies = dependencies
        self.navigationController = navigationController
    }

    func start() {
        let search = UIViewControllerFactory.createSearchViewController(coordinator: self)
        navigationController.setViewControllers([search], animated: false)
    }
}
