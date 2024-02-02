//
//  StringExtension.swift
//  RSSReader
//
//  Created by Fabijan Mihanović on 26.01.2024..
//

import Foundation

extension String {
    func localize() -> String {
        return NSLocalizedString(self, comment: "")
    }
}
