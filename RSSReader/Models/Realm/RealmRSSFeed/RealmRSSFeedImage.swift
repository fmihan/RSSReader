//
//  RealmRSSFeedImage.swift
//  RSSReader
//
//  Created by Fabijan Mihanović on 30.01.2024..
//

import FeedKit
import Foundation
import RealmSwift

class RealmRSSFeedImage: Object {

    @Persisted(primaryKey: true) var id: String = UUID().uuidString

    /// The URL of a GIF, JPEG or PNG image that represents the channel.
    @Persisted var url: String?

    /// Describes the image, it's used in the ALT attribute of the HTML `<img>`
    /// tag when the channel is rendered in HTML.
    @Persisted var title: String?

    /// The URL of the site, when the channel is rendered, the image is a link
    /// to the site. (Note, in practice the image `<title>` and `<link>` should
    /// have the same value as the channel's `<title>` and `<link>`.
    @Persisted var link: String?

    /// Optional element `<width>` indicating the width of the image in pixels.
    /// Maximum value for width is 144, default value is 88.
    @Persisted var width: Int?

    /// Optional element `<height>` indicating the height of the image in pixels.
    /// Maximum value for height is 400, default value is 31.
    @Persisted var height: Int?

    /// Contains text that is included in the TITLE attribute of the link formed
    /// around the image in the HTML rendering.
    @Persisted var feedImageDescription: String?
}



extension RealmRSSFeedImage {

    func assignValues(from image: RSSFeedImage?) {
        guard let image else { return }

        url = image.url
        title = image.title
        link = image.link
        width = image.width
        height = image.height
        feedImageDescription = image.description
    }

}
