//
//  UIViewControllerFactory.swift
//  RSSReader
//
//  Created by Fabijan Mihanović on 31.01.2024..
//

import UIKit

class UIViewControllerFactory {

    static var dependencies: AppDependency!

    static func createHomeViewController() -> HomeViewController {
        let viewController = HomeViewController()
        let viewModel = HomeViewModel(feedService: dependencies.feedService)
        viewController.viewModel = viewModel
        
        return viewController
    }

}
