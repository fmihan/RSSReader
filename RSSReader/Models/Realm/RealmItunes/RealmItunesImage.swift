//
//  RealmItunesImage.swift
//  RSSReader
//
//  Created by Fabijan Mihanović on 30.01.2024..
//

import FeedKit
import Foundation
import RealmSwift

class RealmItunesImage: Object {

    @Persisted(primaryKey: true) var id: String = UUID().uuidString

    @Persisted var href: String?

}

extension RealmItunesImage {

    func assignValues(from image: ITunesImage?) {
        guard let image else { return }
        href = image.attributes?.href
    }

}
