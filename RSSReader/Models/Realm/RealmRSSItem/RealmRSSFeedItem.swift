//
//  RealmRSSFeedItem.swift
//  RSSReader
//
//  Created by Fabijan Mihanović on 30.01.2024..
//

import FeedKit
import Foundation
import RealmSwift

class RealmRSSFeedItem: Object, Imaginable, SizingCellProtocol, Timeable, Categorizable {

    @Persisted(primaryKey: true) var id: String = UUID().uuidString

    // MARK: - Local Data
    @Persisted var readDate: Date?
    @Persisted var publisherId: String?
    @Persisted var isFavorite: Bool = false

    // MARK: - External Properties

    /// The title of the item.
    ///
    /// Example: Venice Film Festival Tries to Quit Sinking
    @Persisted var title: String?

    /// The URL of the item.
    ///
    /// Example: http://nytimes.com/2004/12/07FEST.html
    @Persisted var link: String?

    /// The item synopsis.
    ///
    /// Example: Some of the most heated chatter at the Venice Film Festival this
    /// week was about the way that the arrival of the stars at the Palazzo del
    /// Cinema was being staged.
    @Persisted var feedItemDescription: String?

    /// Email address of the author of the item.
    ///
    /// Example: oprah\@oxygen.net
    ///
    /// <author> is an optional sub-element of <item>.
    ///
    /// It's the email address of the author of the item. For newspapers and
    /// magazines syndicating via RSS, the author is the person who wrote the
    /// article that the <item> describes. For collaborative weblogs, the author
    /// of the item might be different from the managing editor or webmaster.
    /// For a weblog authored by a single individual it would make sense to omit
    /// the <author> element.
    ///
    /// <author>lawyer@boyer.net (Lawyer Boyer)</author>
    @Persisted var author: String?

    /// Includes the item in one or more categories.
    ///
    /// <category> is an optional sub-element of <item>.
    ///
    /// It has one optional attribute, domain, a string that identifies a
    /// categorization taxonomy.
    ///
    /// The value of the element is a forward-slash-separated string that
    /// identifies a hierarchic location in the indicated taxonomy. Processors
    /// may establish conventions for the interpretation of categories.
    ///
    /// Two examples are provided below:
    ///
    /// <category>Grateful Dead</category>
    /// <category domain="http://www.fool.com/cusips">MSFT</category>
    ///
    /// You may include as many category elements as you need to, for different
    /// domains, and to have an item cross-referenced in different parts of the
    /// same domain.
    @Persisted var categories = List<RealmRSSFeedItemCategory>()

    /// URL of a page for comments relating to the item.
    ///
    /// Example: http://www.myblog.org/cgi-local/mt/mt-comments.cgi?entry_id=290
    ///
    /// <comments> is an optional sub-element of <item>.
    ///
    /// If present, it is the url of the comments page for the item.
    ///
    /// <comments>http://ekzemplo.com/entry/4403/comments</comments>
    ///
    /// More about comments here:
    /// http://cyber.law.harvard.edu/rss/weblogComments.html
    @Persisted var comments: String?

    /// Describes a media object that is attached to the item.
    ///
    /// <enclosure> is an optional sub-element of <item>.
    ///
    /// It has three required attributes. url says where the enclosure is located,
    /// length says how big it is in bytes, and type says what its type is, a
    /// standard MIME type.
    ///
    /// The url must be an http url.
    ///
    /// <enclosure url="http://www.scripting.com/mp3s/weatherReportSuite.mp3"
    /// length="12216320" type="audio/mpeg" />
    @Persisted var enclosure: RealmRSSFeedItemEnclosure? = RealmRSSFeedItemEnclosure()

    /// A string that uniquely identifies the item.
    ///
    /// Example: http://inessential.com/2002/09/01.php#a2
    ///
    /// <guid> is an optional sub-element of <item>.
    ///
    /// guid stands for globally unique identifier. It's a string that uniquely
    /// identifies the item. When present, an aggregator may choose to use this
    /// string to determine if an item is new.
    ///
    /// <guid>http://some.server.com/weblogItem3207</guid>
    ///
    /// There are no rules for the syntax of a guid. Aggregators must view them
    /// as a string. It's up to the source of the feed to establish the
    /// uniqueness of the string.
    ///
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
    @Persisted var guid: RealmRSSFeedItemGUID? = RealmRSSFeedItemGUID()

    /// Indicates when the item was published.
    ///
    /// Example: Sun, 19 May 2002 15:21:36 GMT
    ///
    /// <pubDate> is an optional sub-element of <item>.
    ///
    /// Its value is a date, indicating when the item was published. If it's a
    /// date in the future, aggregators may choose to not display the item until
    /// that date.
    @Persisted var pubDate: Date?

    /// The RSS channel that the item came from.
    ///
    /// <source> is an optional sub-element of <item>.
    ///
    /// Its value is the name of the RSS channel that the item came from, derived
    /// from its <title>. It has one required attribute, url, which links to the
    /// XMLization of the source.
    ///
    /// <source url="http://www.tomalak.org/links2.xml">Tomalak's Realm</source>
    ///
    /// The purpose of this element is to propagate credit for links, to
    /// publicize the sources of news items. It can be used in the Post command
    /// of an aggregator. It should be generated automatically when forwarding
    /// an item from an aggregator to a weblog authoring tool.
    @Persisted var source: RealmRSSFeedItemGUID? = RealmRSSFeedItemGUID()


    // MARK: - Namespaces

    /// A module for the actual content of websites, in multiple formats.
    ///
    /// See http://web.resource.org/rss/1.0/modules/content/
    @Persisted var content: RealmContentNamespace? = RealmContentNamespace()

    /// iTunes Podcasting Tags are de facto standard for podcast syndication.
    /// see https://help.apple.com/itc/podcasts_connect/#/itcb54353390
    @Persisted var iTunes: RealmITunesNamespace? = RealmITunesNamespace()

}

extension RealmRSSFeedItem {

    func assignValues(from feedItem: RSSFeedItem?) {
        guard let feedItem else { return }

        title = feedItem.title
        link = feedItem.link
        feedItemDescription = feedItem.description
        author = feedItem.author
        comments = feedItem.comments
        pubDate = feedItem.pubDate

        categories.assignValues(from: feedItem.categories)
        enclosure?.assignValues(from: feedItem.enclosure)
        guid?.assignValues(from: feedItem.guid)
        content?.assignValues(from: feedItem.content)
        iTunes?.assignValues(from: feedItem.iTunes)
    }

}
