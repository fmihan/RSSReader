//
//  UILabelExtension.swift
//  RSSReader
//
//  Created by Fabijan Mihanović on 26.01.2024..
//

import UIKit

extension UILabel {
    convenience init(text: String?, textColor: UIColor?, font: UIFont?) {
        self.init()
        self.text = text
        self.textColor = textColor
        self.font = font
    }
}

