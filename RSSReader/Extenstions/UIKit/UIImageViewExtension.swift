//
//  UIImageViewExtension.swift
//  RSSReader
//
//  Created by Fabijan Mihanović on 26.01.2024..
//

import UIKit
import Kingfisher

extension UIImageView {

    typealias KingfisherCompletion = ((Result<RetrieveImageResult, KingfisherError>) -> Void)?

    func setKFImage(from imageUrl: String?, placeholder: UIImage?, completionHandler: KingfisherCompletion = nil) {
        guard let imageUrl, let url = URL(string: imageUrl) else {
            self.image = placeholder
            return
        }

        let resource = KF.ImageResource(downloadURL: url, cacheKey: imageUrl)

        self.kf.indicatorType = .activity
        self.kf.setImage(
            with: resource,
            placeholder: placeholder,
            options: [
                .transition(.fade(0.2))
            ],
            completionHandler: completionHandler
        )
    }
}

