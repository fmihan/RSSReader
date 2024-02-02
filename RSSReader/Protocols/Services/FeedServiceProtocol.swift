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
    var isRefreshingPublisher: AnyPublisher<Bool, Never> { get }
    var updatedItemPublisher: AnyPublisher<String, Never> { get }
    var removedFeedPublisher: AnyPublisher<String, Never> { get }
    var subscibedPortalsPublisher: AnyPublisher<[RealmRSSFeed], Never> { get }

    // MARK: - Network Calls
    func refreshFeed()
    func addNewFeed(with url: String)

    // MARK: - Local queries
    func loadPublishers()
    func searchFor(_ searchText: String) -> AnyPublisher<[RSSItemWithInfo], Never>
    func fetchFeed(withPublisherId id: String?) -> AnyPublisher<[RSSItemWithInfo], Never>

    // MARK: - RSS Actions
    func bookmarkItem(_ id: String)
    func removeItem(with id: String)
    func markItemAsRead(_ id: String)
    func removeProvider(with id: String)
}
