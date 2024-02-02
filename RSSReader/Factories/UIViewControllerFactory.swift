//
//  UIViewControllerFactory.swift
//  RSSReader
//
//  Created by Fabijan Mihanović on 31.01.2024..
//

import UIKit

class UIViewControllerFactory {

    static var dependencies: AppDependency!

    static func createHomeParchmentViewController() -> MainHomepageViewController {
        let viewController = MainHomepageViewController()
        let viewModel = MainHomepageViewModel(feedService: dependencies.feedService)
        viewController.viewModel = viewModel
        
        return viewController
    }

    static func createFeedViewController(withPublisherId id: String? = nil) -> FeedViewController {
        let viewController = FeedViewController()
        let viewModel = FeedViewModel(feedService: dependencies.feedService, specifiedProviderId: id)
        viewController.viewModel = viewModel
        
        return viewController
    }

}
