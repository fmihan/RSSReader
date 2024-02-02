//
//  CategorizableProtocol.swift
//  RSSReader
//
//  Created by Fabijan Mihanović on 02.02.2024..
//

import RealmSwift

protocol Categorizable {
    var categories: List<RealmRSSFeedItemCategory> { get }
}

extension Categorizable {
    var hasCategories: Bool {
        !categories.isEmpty
    }

    var firstCategoryName: String {
        categories.first?.value ?? ""
    }
}
