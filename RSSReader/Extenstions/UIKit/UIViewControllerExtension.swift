//
//  UIViewControllerExtension.swift
//  RSSReader
//
//  Created by Fabijan Mihanović on 26.01.2024..
//

import UIKit

// MARK: - Loader

private var loader: UIActivityIndicatorView?

extension UIViewController {
    func addLoader() {
        loader = UIActivityIndicatorView(style: .large)
        loader?.isHidden = true

        guard let loader = loader else { return }
        view.addSubview(loader)

        loader.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }

    func animateLoader() {
        loader?.startAnimating()
    }

    func stopLoader() {
        loader?.stopAnimating()
    }
}


