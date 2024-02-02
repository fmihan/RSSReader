//
//  RealmRSSItem.swift
//  RSSReader
//
//  Created by Fabijan Mihanović on 30.01.2024..
//

import FeedKit
import Foundation
import RealmSwift

class RealmRSSFeed: Object {

    @Persisted(primaryKey: true) var id: String = UUID().uuidString

    /// The name of the channel. It's how people refer to your service. If
    /// you have an HTML website that contains the same information as your
    /// RSS file, the title of your channel should be the same as the title
    /// of your website.
    ///
    /// Example: GoUpstate.com News Headlines
    @Persisted var title: String?

    /// The URL to the HTML website corresponding to the channel.
    ///
    /// Example: http://www.goupstate.com/
    @Persisted var link: String?

    /// Phrase or sentence describing the channel.
    ///
    /// Example: The latest news from GoUpstate.com, a Spartanburg Herald-Journal
    /// Web site.
    @Persisted var feedDescription: String?

    /// The language the channel is written in. This allows aggregators to group
    /// all Italian language sites, for example, on a single page. A list of
    /// allowable values for this element, as provided by Netscape, is here:
    /// http://cyber.law.harvard.edu/rss/languages.html
    ///
    /// You may also use values defined by the W3C:
    /// http://www.w3.org/TR/REC-html40/struct/dirlang.html#langcodes
    ///
    /// Example: en-us
    @Persisted var language: String?

    /// Copyright notice for content in the channel.
    ///
    /// Example: Copyright 2002, Spartanburg Herald-Journal
    @Persisted var copyright: String?

    /// Email address for person responsible for editorial content.
    ///
    /// Example: geo@herald.com (George Matesky)
    @Persisted var managingEditor: String?

    /// Email address for person responsible for technical issues relating to
    /// channel.
    ///
    /// Example: betty@herald.com (Betty Guernsey)
    @Persisted var webMaster: String?

    /// The @Persistedation date for the content in the channel. For example, the
    /// New York Times publishes on a daily basis, the publication date flips
    /// once every 24 hours. That's when the pubDate of the channel changes.
    /// All date-times in RSS conform to the Date and Time Specification of
    /// RFC 822, with the exception that the year may be expressed with two
    /// characters or four characters (four preferred).
    ///
    /// Example: Sat, 07 Sep 2002 00:00:01 GMT
    @Persisted var pubDate: Date?

    /// The last time the content of the channel changed.
    ///
    /// Example: Sat, 07 Sep 2002 09:42:31 GMT
    @Persisted var lastBuildDate: Date?

    /// Specify one or more categories that the channel belongs to. Follows the
    /// same rules as the <item>-level category element.
    ///
    /// Example: Newspapers
    @Persisted var categories = List<RealmRSSFeedCategory>()

    /// A string indicating the program used to generate the channel.
    ///
    /// Example: MightyInHouse Content System v2.3
    @Persisted var generator: String?

    /// A URL that points to the documentation for the format used in the RSS
    /// file. It's probably a pointer to this page. It's for people who might
    /// stumble across an RSS file on a Web server 25 years from now and wonder
    /// what it is.
    ///
    /// Example: http://blogs.law.harvard.edu/tech/rss
    @Persisted var docs: String?

    /// Allows processes to register with a cloud to be notified of updates to
    /// the channel, implementing a lightweight publish-subscribe protocol for
    /// RSS feeds.
    ///
    /// Example: <cloud domain="rpc.sys.com" port="80" path="/RPC2" registerProcedure="pingMe" protocol="soap"/>
    ///
    /// <cloud> is an optional sub-element of <channel>.
    ///
    /// It specifies a web service that supports the rssCloud interface which can
    /// be implemented in HTTP-POST, XML-RPC or SOAP 1.1.
    ///
    /// Its purpose is to allow processes to register with a cloud to be notified
    /// of updates to the channel, implementing a lightweight publish-subscribe
    /// protocol for RSS feeds.
    ///
    /// <cloud domain="rpc.sys.com" port="80" path="/RPC2" registerProcedure="myCloud.rssPleaseNotify" protocol="xml-rpc" />
    ///
    /// In this example, to request notification on the channel it appears in,
    /// you would send an XML-RPC message to rpc.sys.com on port 80, with a path
    /// of /RPC2. The procedure to call is myCloud.rssPleaseNotify.
    ///
    /// A full explanation of this element and the rssCloud interface is here:
    /// http://cyber.law.harvard.edu/rss/soapMeetsRss.html#rsscloudInterface
    @Persisted var cloud: RealmRSSFeedCloud? = RealmRSSFeedCloud()

    /// The PICS rating for the channel.
    @Persisted var rating: String?

    /// ttl stands for time to live. It's a number of minutes that indicates how
    /// long a channel can be cached before refreshing from the source.
    ///
    /// Example: 60
    ///
    /// <ttl> is an optional sub-element of <channel>.
    ///
    /// ttl stands for time to live. It's a number of minutes that indicates how
    /// long a channel can be cached before refreshing from the source. This makes
    /// it possible for RSS sources to be managed by a file-sharing network such
    /// as Gnutella.
    @Persisted var ttl: Int?

    /// Specifies a GIF, JPEG or PNG image that can be displayed with the channel.
    ///
    /// <image> is an optional sub-element of <channel>, which contains three
    /// required and three optional sub-elements.
    ///
    /// <url> is the URL of a GIF, JPEG or PNG image that represents the channel.
    ///
    /// <title> describes the image, it's used in the ALT attribute of the HTML
    /// <img> tag when the channel is rendered in HTML.
    ///
    /// <link> is the URL of the site, when the channel is rendered, the image
    /// is a link to the site. (Note, in practice the image <title> and <link>
    /// should have the same value as the channel's <title> and <link>.
    ///
    /// Optional elements include <width> and <height>, numbers, indicating the
    /// width and height of the image in pixels. <description> contains text
    /// that is included in the TITLE attribute of the link formed around the
    /// image in the HTML rendering.
    ///
    /// Maximum value for width is 144, default value is 88.
    ///
    /// Maximum value for height is 400, default value is 31.
    @Persisted var image: RealmRSSFeedImage? = RealmRSSFeedImage()


    // MARK: - Namespaces

    /// iTunes Podcasting Tags are de facto standard for podcast syndication.
    /// See https://help.apple.com/itc/podcasts_connect/#/itcb54353390
    @Persisted var iTunes: RealmITunesNamespace? = RealmITunesNamespace()
}

extension RealmRSSFeed {

    func assignValues(from rssFeed: RSSFeed) {

        title = rssFeed.title
        link = rssFeed.link
        feedDescription = rssFeed.description
        language = rssFeed.language
        copyright = rssFeed.copyright
        managingEditor = rssFeed.managingEditor
        webMaster = rssFeed.webMaster
        pubDate = rssFeed.pubDate
        lastBuildDate = rssFeed.lastBuildDate
        generator = rssFeed.generator
        docs = rssFeed.docs
        rating = rssFeed.rating
        ttl = rssFeed.ttl

        image?.assignValues(from: rssFeed.image)
        cloud?.assignValues(from: rssFeed.cloud)
        categories.assignValues(from: rssFeed.categories)
        iTunes?.assignValues(from: rssFeed.iTunes)
    }

}
