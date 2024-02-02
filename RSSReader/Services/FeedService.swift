//
//  FeedServiceProtocol.swift
//  RSSReader
//
//  Created by Fabijan Mihanović on 31.01.2024..
//

import Combine
import Foundation

class FeedService: FeedServiceProtocol {

    private var isRefreshingSubject = PassthroughSubject<Bool, Never>()
    var isRefreshingPublisher: AnyPublisher<Bool, Never> {
        isRefreshingSubject.eraseToAnyPublisher()
    }

    private var updatedItemSubject = PassthroughSubject<String, Never>()
    var updatedItemPublisher: AnyPublisher<String, Never> {
        updatedItemSubject.eraseToAnyPublisher()
    }

    private var feedPublisherSubject = PassthroughSubject<[RSSItemWithInfo], Never>()
    var feedPublisherPublisher: AnyPublisher<[RSSItemWithInfo], Never> {
        feedPublisherSubject.eraseToAnyPublisher()
    }

    private var removedFeedSubject = PassthroughSubject<String, Never>()
    var removedFeedPublisher: AnyPublisher<String, Never> {
        removedFeedSubject.eraseToAnyPublisher()
    }

    private var rssPublishers: [RealmRSSFeed] = []
    private var cancellables = Set<AnyCancellable>()

    var api: RSSReaderApiProtocol
    var realm: RealmServiceProtocol

    init(realm: RealmServiceProtocol, api: RSSReaderApiProtocol) {
        self.realm = realm
        self.api = api

        loadPublisers()
    }

    private func loadPublisers() {
        
    }

    // MARK: - Network Calls

    func refreshFeed() {
        isRefreshingSubject.send(true)

    }

    func addNewFeed(with url: String) {
        api.fetchRSS(with: url)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { value in
                switch value {
                case .finished:
                    fprint("Successfully fetched data for feed with url: \(url)", type: .apiResponse)
                case .failure(let failure):
                    fprint("Error occured while fetching RSS feed with url: \(url)", type: .apiCallError, isError: true)
                }
            }, receiveValue: { [unowned self] response in
                dump(response.items?.first)
                realm.manageData(from: response)
                fetchFeed()
            })
            .store(in: &cancellables)
    }

    func requestSummary(for providerIds: [String]) {
        //
    }

    // MARK: - Local queries

    func fetchFeed() {
        let feed = realm.getFeed(withPublisher: nil)
        feedPublisherSubject.send(feed)
    }

    func searchFor(_ searchText: String) {
        if searchText.isEmpty {
            fetchFeed()
        } else {
            feedPublisherSubject.send(realm.performFuzzySearch(with: searchText))
        }
    }

    func showItemsFor(provider id: String) {
        //
    }

    // MARK: - RSS Actions

    func bookmarkItem(_ id: String) {
        //
    }

    func removeItem(with id: String) {
        //
    }

    func markItemAsRead(_ id: String) {
        //
    }

    func removeProvider(with id: String) {
        //
    }
}
