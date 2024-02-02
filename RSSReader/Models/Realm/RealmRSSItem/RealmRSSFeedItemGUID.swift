//
//  RealmRSSFeedItemGUID.swift
//  RSSReader
//
//  Created by Fabijan Mihanović on 30.01.2024..
//

import FeedKit
import Foundation
import RealmSwift

class RealmRSSFeedItemGUID: Object {

    @Persisted(primaryKey: true) var id: String = UUID().uuidString

    /// If the guid element has an attribute named "isPermaLink" with a value of
    /// true, the reader may assume that it is a permalink to the item, that is,
    /// a url that can be opened in a Web browser, that points to the full item
    /// described by the <item> element. An example:
    ///
    /// <guid isPermaLink="true">http://inessential.com/2002/09/01.php#a2</guid>
    ///
    /// isPermaLink is optional, its default value is true. If its value is false,
    /// the guid may not be assumed to be a url, or a url to anything in
    /// particular.
    @Persisted var isPermaLink: Bool?

    /// The element's value.
    @Persisted var value: String?

}

extension RealmRSSFeedItemGUID {

    func assignValues(from guid: RSSFeedItemGUID?) {
        guard let guid else { return }
        isPermaLink = guid.attributes?.isPermaLink
        value = guid.value
    }

}
