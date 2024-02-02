//
//  RealmRSSFeedCategory.swift
//  RSSReader
//
//  Created by Fabijan Mihanović on 30.01.2024..
//

import FeedKit
import Foundation
import RealmSwift

class RealmRSSFeedCategory: Object {
    
    @Persisted(primaryKey: true) var id: String = UUID().uuidString

    /// A string that identifies a categorization taxonomy. It's an optional
    /// attribute of `<category>`. e.g. "http://www.fool.com/cusips"
    @Persisted var domain: String?

    /// The element's value.
    @Persisted var value: String?

}

extension List where Element == RealmRSSFeedCategory {

    func assignValues(from categories: [RSSFeedCategory]?) {
        guard let categories = categories else { return }
        let list = categories.map { realmCategory($0) }
        self.append(objectsIn: list)
    }

    private func realmCategory(_ category: RSSFeedCategory) -> RealmRSSFeedCategory {
        let realmCategory = RealmRSSFeedCategory()
        realmCategory.domain = category.attributes?.domain
        realmCategory.value = category.value
        return realmCategory
    }
}
