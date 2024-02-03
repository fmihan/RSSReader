//
//  RealmService.swift
//  RSSReader
//
//  Created by Fabijan Mihanović on 31.01.2024..
//

import FeedKit
import Foundation
import RealmSwift

class RealmService: RealmServiceProtocol {

    var realm: Realm?

    init() {
        let groupName = "com.personal.fm.RSSReader"
        let realmFileName = "default.realm"

        do {
            if let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: groupName) {
                let realmURL = containerURL.appendingPathComponent(realmFileName)
                let config = Realm.Configuration(fileURL: realmURL)
                realm = try Realm(configuration: config)
            }
        } catch {
            fprint("Realm init error = \(error)", type: .realmSavingError, isError: true)
        }
    }

    // MARK: - FeedKit Mappers
    func manageData(from rssFeed: RSSFeed, enteredLink: String) {
        guard let publisherLink = rssFeed.link, let existingPublishers = getPublishers() else {
            return
        }

        var publisherId: String?
        let filteredPublishers = existingPublishers.filter("link == %@", publisherLink)

        if existingPublishers.isEmpty || filteredPublishers.isEmpty {
            publisherId = createNewPublisher(via: rssFeed, enteredLink: enteredLink)
        } else if let existingPublisherId = filteredPublishers.first?.id {
            publisherId = existingPublisherId
        }

        guard let items = rssFeed.items else { return }

        let existingFeed = loadFeed()

        for rssItem in items {
            guard let itemLink = rssItem.link,
                  let itemsWithLink = existingFeed?.filter("link == %@", itemLink),
                  itemsWithLink.isEmpty else {
                continue
            }

            let newItem = RealmRSSFeedItem()
            newItem.publisherId = publisherId
            newItem.assignValues(from: rssItem)
            saveFeed(newItem)
        }
    }

    private func createNewPublisher(via rssFeed: RSSFeed, enteredLink: String) -> String {
        let newPublisher = RealmRSSFeed()
        newPublisher.enteredLink = enteredLink
        newPublisher.assignValues(from: rssFeed)
        savePublisher(newPublisher)
        return newPublisher.id
    }


    // MARK: - Publisher Managers
    func getPublishers() -> Results<RealmRSSFeed>? {
        let publishers = realm?.objects(RealmRSSFeed.self)
        fprint("Fetched publishers", type: .realm)
        return publishers
    }

    func savePublisher(_ publisher: RealmRSSFeed) {
        fprint("Saving new publisher", type: .realm)
        do {
            try realm?.write {
                realm?.add(publisher)
            }
        } catch {
            fprint("Realm write error = \(error)", type: .realm, isError: true)
        }
    }

    func removePublisher(with id: String) {
        fprint("Removing publisher with id: \(id)", type: .realm)
        guard let publisher = realm?.object(ofType: RealmRSSFeed.self, forPrimaryKey: id) else { return }
        do {
            try realm?.write {
                realm?.delete(publisher)
            }
        } catch {
            fprint("Realm delete error = \(error)", type: .realm, isError: true)
        }

        if let articles = loadFeed(forPublisher: id) {
            articles.forEach { item in
                removeFeed(item.id)
            }
        }
    }

    // MARK: - Feed Item Manager

    func removeFeed(_ id: String) {
        fprint("Removing feed item with id: \(id)", type: .realm)
        guard let feedItem = realm?.object(ofType: RealmRSSFeedItem.self, forPrimaryKey: id) else { return }
        do {
            try realm?.write {
                realm?.delete(feedItem)
            }
        } catch {
            fprint("Realm delete error = \(error)", type: .realm, isError: true)
        }
    }

    func saveFeed(_ item: RealmRSSFeedItem) {
        fprint("Saving new feed item", type: .realm)
        do {
            try realm?.write {
                realm?.add(item)
            }
        } catch {
            fprint("Realm write error = \(error)", type: .realm, isError: true)
        }
    }

    func markAsBookmaked(_ updatedItem: RealmRSSFeedItem) {
        fprint("Bookmarking feed item", type: .realm)
        do {
            try realm?.write {
                updatedItem.isFavorite = !updatedItem.isFavorite
            }
        } catch {
            fprint("Realm write error = \(error)", type: .realm, isError: true)
        }
    }

    func markAsRead(_ updatedItem: RealmRSSFeedItem) {
        fprint("Bookmarking feed item", type: .realm)
        do {
            try realm?.write {
                updatedItem.readDate = Date()
            }
        } catch {
            fprint("Realm write error = \(error)", type: .realm, isError: true)
        }
    }

    func loadFeed(forPublisher id: String? = nil) -> Results<RealmRSSFeedItem>? {
        guard var results = realm?.objects(RealmRSSFeedItem.self) else { return nil }

        if let publisherId = id {
            results = results.filter("publisherId == %@", publisherId)
        }

        results = results.sorted(byKeyPath: "pubDate", ascending: false)

        return results
    }

    // MARK: - UI Representable Data

    func getReadItems() -> [RSSItemWithInfo] {
        return mapToRSSItemWithInfo(
            feedItems: loadFeed()?
                        .filter("readDate != null")
                        .sorted(byKeyPath: "readDate", ascending: false),
            publishers: getPublishers()
        )
    }

    func getBookmarkedItems() -> [RSSItemWithInfo] {
        return mapToRSSItemWithInfo(feedItems: loadFeed()?.filter("isFavorite == true"), publishers: getPublishers())
    }

    func getFeed(withPublisher id: String? = nil) -> [RSSItemWithInfo] {
        if let id, let feedItems = loadFeed(forPublisher: id), let publishers = getPublishers()?.filter("id == %@", id) {
            return mapToRSSItemWithInfo(feedItems: feedItems, publishers: publishers)
        }

        return mapToRSSItemWithInfo(feedItems: loadFeed(), publishers: getPublishers())
    }

    func performFuzzySearch(with searchText: String) -> [RSSItemWithInfo] {
        return mapToRSSItemWithInfo(feedItems: loadFeed()?.filter("title LIKE[c] %@ OR feedItemDescription LIKE[c] %@", "*\(searchText)*", "*\(searchText)*"), publishers: getPublishers())
    }

    private func mapToRSSItemWithInfo(feedItems: Results<RealmRSSFeedItem>?, publishers: Results<RealmRSSFeed>?) -> [RSSItemWithInfo] {
        guard let feedItems = feedItems, let publishers = publishers else { return [] }

        var items: [RSSItemWithInfo] = []
        for feedItem in feedItems {
            guard let publisher = publishers.first(where: { $0.id == feedItem.publisherId }) else { continue }
            items.append(RSSItemWithInfo(publisher: publisher, item: feedItem))
        }

        return items
    }



    // MARK: - Delete all data

    func deleteAll() {
        try? realm?.write {
            realm?.deleteAll()
        }
    }
}
