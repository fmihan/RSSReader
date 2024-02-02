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
    func pushToWebView(url: String?)
}

extension CSafariViewProtocol {
    func pushToWebView(url: String?) {
        guard let stringUrl = url?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: stringUrl), UIApplication.shared.canOpenURL(url) else { return }
        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = true
        let vc = SFSafariViewController(url: url, configuration: config)
        vc.title = nil
        navigationController.present(vc, animated: true)
    }
}
