//
//  RealmRSSFeedItemSource.swift
//  RSSReader
//
//  Created by Fabijan Mihanović on 30.01.2024..
//

import Foundation
import RealmSwift

class RealmRSSFeedItemSource: Object {

    @Persisted(primaryKey: true) var id: String = UUID().uuidString

    /// Required attribute of the `Source` element, which links to the
    /// XMLization of the source. e.g. "http://www.tomalak.org/links2.xml"
    @Persisted var url: String?

    /// The element's value.
    @Persisted var value: String?
}
