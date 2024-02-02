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
    var isRefreshingPublisher: AnyPublisher<Bool, Never> { get }
    var updatedItemPublisher: AnyPublisher<String, Never> { get }
    var feedPublisherPublisher: AnyPublisher<[RSSItemWithInfo], Never> { get }
    var removedFeedPublisher: AnyPublisher<String, Never> { get }

    // MARK: - Network Calls
    func refreshFeed()
    func addNewFeed(with url: String)
    func requestSummary(for providerIds: [String])

    // MARK: - Local queries

    func fetchFeed()
    func searchFor(_ searchText: String)
    func showItemsFor(provider id: String)

    // MARK: - RSS Actions
    func bookmarkItem(_ id: String)
    func removeItem(with id: String)
    func markItemAsRead(_ id: String)
    func removeProvider(with id: String)
}
