//
//  FeedServiceProtocol.swift
//  RSSReader
//
//  Created by Fabijan Mihanović on 31.01.2024..
//

import Combine
import Foundation

protocol FeedServiceProtocol {
    // MARK: - Publihsers
    var refreshViewsPublisher: AnyPublisher<Void, Never> { get }
    var updatedItemPublisher: AnyPublisher<RealmRSSFeedItem, Never> { get }
    var subscibedPortalsPublisher: AnyPublisher<[RealmRSSFeed], Never> { get }

    // MARK: - Network Calls
    func addNewFeed(with url: String)

    // MARK: - Local queries
    func loadPublishers()
    func loadHistory() -> AnyPublisher<[RSSItemWithInfo], Never>
    func loadBookmarks() -> AnyPublisher<[RSSItemWithInfo], Never>
    func searchFor(_ searchText: String) -> AnyPublisher<[RSSItemWithInfo], Never>
    func fetchFeed(withPublisherId id: String?) -> AnyPublisher<[RSSItemWithInfo], Never>

    // MARK: - RSS Actions
    func removeProvider(with id: String?)
    func bookmarkItem(_ item: RealmRSSFeedItem)
    func markItemAsRead(_ item: RealmRSSFeedItem)
}
