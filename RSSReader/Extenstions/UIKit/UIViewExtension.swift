//
//  UIViewExtension.swift
//  RSSReader
//
//  Created by Fabijan Mihanović on 27.01.2024..
//

import UIKit

extension UIView {
    func setShadow(
        color: UIColor = .black,
        radius: CGFloat = 6,
        offset: CGSize = CGSize(
            width: 0,
            height: 4
        ),
        opacity: Float = 0.15
    ) {
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
    }
}
