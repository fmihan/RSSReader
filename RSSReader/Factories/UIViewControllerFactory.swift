//
//  UIViewControllerFactory.swift
//  RSSReader
//
//  Created by Fabijan Mihanović on 31.01.2024..
//

import UIKit

class UIViewControllerFactory {

    static var dependencies: AppDependency!

    static func createHomeParchmentViewController(coordinator: HomeCoordinator?) -> MainHomepageViewController {
        let viewController = MainHomepageViewController()
        let viewModel = MainHomepageViewModel(feedService: dependencies.feedService)
        viewModel.homeCoordinator = coordinator
        viewController.viewModel = viewModel
        return viewController
    }

    static func createFeedViewController(coordinator: HomeCoordinator?, withPublisherId id: String? = nil) -> FeedViewController {
        let viewController = FeedViewController()
        let viewModel = FeedViewModel(feedService: dependencies.feedService, specifiedProviderId: id)
        viewModel.coordinator = coordinator
        viewController.viewModel = viewModel
        return viewController
    }

    static func createAddRSSViewController(coordinator: HomeCoordinator?) -> AddRSSViewController {
        let viewController = AddRSSViewController()
        viewController.hidesBottomBarWhenPushed = true
        let viewModel = AddRSSViewModel(api: dependencies.api, feedService: dependencies.feedService)
        viewModel.homeCoordinator = coordinator
        viewController.viewModel = viewModel
        return viewController
    }

    static func createSearchViewController(coordinator: SearchCoordinator) -> SearchViewController {
        let viewController = SearchViewController()
        let viewModel = SearchViewModel(feedService: dependencies.feedService)
        viewModel.coordinator = coordinator
        viewController.viewModel = viewModel
        return viewController
    }

    static func createMoreViewController(coordinator: MoreCoordinator) -> MoreViewController {
        let viewController = MoreViewController()
        let viewModel = MoreViewModel()
        viewModel.coordinator = coordinator
        viewController.viewModel = viewModel
        return viewController
    }

    static func createHistoryViewController(coordinator: MoreCoordinator) -> HistoryViewController {
        let viewController = HistoryViewController()
        let viewModel = HistoryViewModel(feedService: dependencies.feedService)
        viewModel.coordinator = coordinator
        viewController.viewModel = viewModel
        return viewController
    }

    static func createFavoritesViewController(coordinator: MoreCoordinator) -> FavoritesViewController {
        let viewController = FavoritesViewController()
        let viewModel = FavoritesViewModel(feedService: dependencies.feedService)
        viewModel.coordinator = coordinator
        viewController.viewModel = viewModel
        return viewController
    }

    static func createOfflinePreviewViewController(with item: RealmRSSFeedItem) -> OfflinePreviewViewController {
        let viewController = OfflinePreviewViewController()
        viewController.item = item
        return viewController
    }

}
