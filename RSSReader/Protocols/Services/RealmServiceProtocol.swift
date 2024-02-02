//
//  RealmServiceProtocol.swift
//  RSSReader
//
//  Created by Fabijan Mihanović on 31.01.2024..
//

import FeedKit
import Combine
import RealmSwift
import Foundation

protocol RealmServiceProtocol {

    // MARK: - FeedKit Mappers
    func manageData(from rssFeed: RSSFeed)

    // MARK: - Publisher Managers
    func getPublishers() -> Results<RealmRSSFeed>?
    func savePublisher(_ publisher: RealmRSSFeed)
    func removePublisher(with id: String)

    // MARK: - Feed Item Manager
    func removeFeed(_ id: String)
    func saveFeed(_ item: RealmRSSFeedItem)
    func updateFeed(_ updatedItem: RealmRSSFeedItem)
    func loadFeed(forPublisher id: String?) -> Results<RealmRSSFeedItem>?

    // MARK: - UI Representable Data
    func getReadItems() -> [RSSItemWithInfo]
    func getBookmarkedItems() -> [RSSItemWithInfo]
    func getFeed(withPublisher id: String?) -> [RSSItemWithInfo]
    func performFuzzySearch(with searchText: String) -> [RSSItemWithInfo]

    // MARK: - Delete all data
    func deleteAll()
}
