//
//  RealmContentNamespace.swift
//  RSSReader
//
//  Created by Fabijan Mihanović on 30.01.2024..
//

import FeedKit
import Foundation
import RealmSwift

class RealmContentNamespace: Object {

    @Persisted(primaryKey: true) var id: String = UUID().uuidString

    /// An element whose contents are the entity-encoded or CDATA-escaped version
    /// of the content of the item.
    ///
    /// Example:
    /// <content:encoded><![CDATA[<p>What a <em>beautiful</em> day!</p>]]>
    /// </content:encoded>
    @Persisted var contentEncoded: String?

}

extension RealmContentNamespace {

    func assignValues(from content: ContentNamespace?) {
        guard let content else { return }
        contentEncoded = content.contentEncoded
    }

}
