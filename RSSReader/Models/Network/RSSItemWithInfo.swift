//
//  RSSItemWithInfo.swift
//  RSSReader
//
//  Created by Fabijan Mihanović on 27.01.2024..
//

import Foundation

class RSSItemWithInfo {
    let publisher: RealmRSSFeed?
    var item: RealmRSSFeedItem?

    init(publisher: RealmRSSFeed?, item: RealmRSSFeedItem?) {
        self.publisher = publisher
        self.item = item
    }
}

extension RSSItemWithInfo {
    func getPublisherAndTime() -> String {
        var start = ""

        if let publisher = publisher?.title {
            start += publisher
        }

        if let time = item?.releaseDate {
            start += start.isEmpty ? "" : " • "
            start += time
        }

        return start
    }
}
