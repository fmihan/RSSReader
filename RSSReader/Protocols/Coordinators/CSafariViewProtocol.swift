//
//  CSafariViewProtocol.swift
//  RSSReader
//
//  Created by Fabijan Mihanović on 02.02.2024..
//

import UIKit
import SafariServices

protocol CSafariViewProtocol {
    var navigationController: NavigationViewController { get }
    var dependencies: AppDependency { get }

    func openItem(_ item: RealmRSSFeedItem)
    func pushToWebView(url: String?)
}

extension CSafariViewProtocol {

    func openItem(_ item: RealmRSSFeedItem) {
        if dependencies.networkMonitorService.isConnected {
            pushToWebView(url: item.link)
        } else {
            openOfflineReader(item: item)
        }
    }

    func openOfflineReader(item: RealmRSSFeedItem) {
        let vc = UIViewControllerFactory.createOfflinePreviewViewController(with: item)
        navigationController.pushViewController(vc, animated: true)
    }

    func pushToWebView(url: String?) {
        guard let stringUrl = url?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: stringUrl), UIApplication.shared.canOpenURL(url) else { return }
        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = true
        let vc = SFSafariViewController(url: url, configuration: config)
        vc.title = nil
        navigationController.present(vc, animated: true)
    }
}
