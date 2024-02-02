//
//  TimeableProtocol.swift
//  RSSReader
//
//  Created by Fabijan Mihanović on 02.02.2024..
//

import Foundation

protocol Timeable {
    var pubDate: Date? { get }
}

extension Timeable {
    var releaseDate: String {
        guard let pubDate, let timeAgo = DateUtils.timeAgo(from: pubDate) else { return "" }
        if let preferredLanguage = Locale.preferredLanguages.first, preferredLanguage.lowercased().hasPrefix("hr") {
            let croatianPrefix = "croatian.prefix.before".localize()
            return croatianPrefix + " " + timeAgo
        } else {
           return timeAgo
        }
    }
}
