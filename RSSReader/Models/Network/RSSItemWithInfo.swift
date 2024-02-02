//
//  RSSItemWithInfo.swift
//  RSSReader
//
//  Created by Fabijan Mihanović on 27.01.2024..
//

import Foundation

class RSSItemWithInfo {
    let publisher: RealmRSSFeed?
    let item: RealmRSSFeedItem?

    init(publisher: RealmRSSFeed?, item: RealmRSSFeedItem?) {
        self.publisher = publisher
        self.item = item
    }
}
