//
//  RealmItunesCategory.swift
//  RSSReader
//
//  Created by Fabijan Mihanović on 30.01.2024..
//

import FeedKit
import Foundation
import RealmSwift

class RealmItunesCategory: Object {

    @Persisted(primaryKey: true) var id: String = UUID().uuidString

    @Persisted var category: String?

    @Persisted var subcategory: String?

}

extension List where Element == RealmItunesCategory {

    func assignValues(from categories: [ITunesCategory]?) {
        guard let categories = categories else { return }
        let list = categories.map { realmCategory($0) }
        self.append(objectsIn: list)
    }

    private func realmCategory(_ category: ITunesCategory) -> RealmItunesCategory {
        let realmCategory = RealmItunesCategory()
        realmCategory.category = category.attributes?.text
        realmCategory.subcategory = category.subcategory?.attributes?.text
        return realmCategory
    }
}
