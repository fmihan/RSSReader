//
//  RealmRSSFeedItemEnclosure.swift
//  RSSReader
//
//  Created by Fabijan Mihanović on 30.01.2024..
//

import FeedKit
import Foundation
import RealmSwift

class RealmRSSFeedItemEnclosure: Object {

    @Persisted(primaryKey: true) var id: String = UUID().uuidString

    /// Where the enclosure is located.
    ///
    /// Example: http://www.scripting.com/mp3s/weatherReportSuite.mp3
    @Persisted var url: String?

    /// How big the media object is in bytes.
    ///
    /// Example: 12216320
    @Persisted var length: Int64?

    /// Standard MIME type.
    ///
    /// Example: audio/mpeg
    @Persisted var type: String?

}

extension RealmRSSFeedItemEnclosure {
    func assignValues(from enclosure: RSSFeedItemEnclosure?) {
        url = enclosure?.attributes?.url
        length = enclosure?.attributes?.length
        type = enclosure?.attributes?.type
    }
}
