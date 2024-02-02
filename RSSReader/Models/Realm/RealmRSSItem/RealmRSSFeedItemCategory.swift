//
//  RealmRSSFeedItemCategory.swift
//  RSSReader
//
//  Created by Fabijan Mihanović on 31.01.2024..
//

import FeedKit
import Foundation
import RealmSwift

class RealmRSSFeedItemCategory: Object {

    @Persisted(primaryKey: true) var id: String = UUID().uuidString

    /// A string that identifies a categorization taxonomy. It's an optional
    /// attribute of `<category>`.
    ///
    /// Example: http://www.fool.com/cusips
    @Persisted var domain: String?


    /// The element's value.
    @Persisted var value: String?

}

extension List where Element == RealmRSSFeedItemCategory {

    func assignValues(from categories: [RSSFeedItemCategory]?) {
        guard let categories else { return }
        let list = categories.map { realmCategory($0) }
        self.append(objectsIn: list)
    }

    private func realmCategory(_ category: RSSFeedItemCategory) -> RealmRSSFeedItemCategory {
        let realmCategory = RealmRSSFeedItemCategory()
        realmCategory.domain = category.attributes?.domain
        realmCategory.value = category.value
        return realmCategory
    }
}
