//
//  ImaginableProtocol.swift
//  RSSReader
//
//  Created by Fabijan Mihanović on 02.02.2024..
//

import Foundation

protocol Imaginable {
    var feedItemDescription: String? { get }
    var content: RealmContentNamespace? { get }
    var enclosure: RealmRSSFeedItemEnclosure? { get }
}

extension Imaginable {

    var hasNoPicture: Bool {
        imageUrl == nil
    }

    var imageUrl: String? {

        if let enclosureUrl = enclosure?.url {
            return enclosureUrl
        }

        if let contentUrl = content?.contentEncoded {
            return contentUrl.extractSource()
        }

        if let feedItemDescription {
            return feedItemDescription.extractSource()
        }

        return nil
    }
}
