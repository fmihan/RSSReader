//
//  SearchCoordinator.swift
//  RSSReader
//
//  Created by Fabijan Mihanović on 02.02.2024..
//

import UIKit
import SafariServices

class SearchCoordinator: CoordinatorProtocol {

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

    func pushToWebView(url: String?) {
        guard let stringUrl = url?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: stringUrl), UIApplication.shared.canOpenURL(url) else { return }
        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = true
        let vc = SFSafariViewController(url: url, configuration: config)
        vc.title = nil
        navigationController.present(vc, animated: true)
    }

    func showActions(for item: RealmRSSFeedItem) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "alert.remove.source".localize(), style: .default, handler: { _ in
            self.dependencies.feedService.removeProvider(with: item.publisherId)
        }))

        alert.addAction(UIAlertAction(title: "alert.share.item".localize(), style: .default, handler: { _ in
            self.share(item.link)
        }))

        alert.addAction(UIAlertAction(title: "alert.bookmark.item".localize(), style: .default, handler: { _ in
            self.dependencies.feedService.bookmarkItem(item)
        }))

        alert.addAction(UIAlertAction(title: "alert.cancel".localize(), style: .cancel, handler: nil))
        navigationController.present(alert, animated: true, completion: nil)
    }

    func share(_ urlString: String?) {
        guard let urlString, let url = URL(string: urlString) else { return }
        let shareSheet = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        navigationController.present(shareSheet, animated: true)
    }
}
