//
//  BaseCoordinator.swift
//  RSSReader
//
//  Created by Fabijan Mihanović on 31.01.2024..
//

import UIKit
import Combine

class BaseCoordinator: CoordinatorProtocol {

    var dependencies: AppDependency
    var childCoordinators: [CoordinatorProtocol] = []
    var navigationController: NavigationViewController
    
    init(navigationController: NavigationViewController, dependencies: AppDependency) {
        self.dependencies = dependencies
        self.navigationController = navigationController
    }

    func start() {
        let tabCoordinator = TabBarCoordinator(navigationController: navigationController, dependencies: dependencies)
        tabCoordinator.parentCoordinator = self
        childCoordinators.append(tabCoordinator)
        tabCoordinator.start()
    }
    

}

