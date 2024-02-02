//
//  FeedServiceProtocol.swift
//  RSSReader
//
//  Created by Fabijan Mihanović on 31.01.2024..
//

import FeedKit
import Combine
import Foundation

class FeedService: FeedServiceProtocol {

    private var refreshViewsSubject = PassthroughSubject<Void, Never>()
    var refreshViewsPublisher: AnyPublisher<Void, Never> {
        refreshViewsSubject.eraseToAnyPublisher()
    }

    private var updatedItemSubject = PassthroughSubject<RealmRSSFeedItem, Never>()
    var updatedItemPublisher: AnyPublisher<RealmRSSFeedItem, Never> {
        updatedItemSubject.eraseToAnyPublisher()
    }

    private var subscibedPortalsSubject = CurrentValueSubject<[RealmRSSFeed], Never>([])
    var subscibedPortalsPublisher: AnyPublisher<[RealmRSSFeed], Never> {
        subscibedPortalsSubject.eraseToAnyPublisher()
    }

    private var rssPublishers: [RealmRSSFeed] = []
    private var cancellables = Set<AnyCancellable>()

    var api: RSSReaderApiProtocol
    var realm: RealmServiceProtocol

    init(realm: RealmServiceProtocol, api: RSSReaderApiProtocol) {
        self.realm = realm
        self.api = api

        loadPublishers()
        fetchAndUpdateAllFeeds()
    }

    func loadPublishers() {
        guard let storedPublishers = realm.getPublishers() else { return }
        let publishers = Array(storedPublishers)
        rssPublishers = publishers
        subscibedPortalsSubject.send(publishers)
    }

    func refreshViews() {
        refreshViewsSubject.send()
    }

    func addNewFeed(with url: String) {
        api.fetchRSS(with: url)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { value in
                switch value {
                case .finished:
                    fprint("Successfully fetched data for feed with url: \(url)", type: .apiResponse)
                case .failure(let failure):
                    fprint("Error occured while fetching RSS feed with url: \(url). Error: \(failure)", type: .apiCallError, isError: true)
                }
            }, receiveValue: { [unowned self] response in
                realm.manageData(from: response, enteredLink: url)
                refreshViews()
            })
            .store(in: &cancellables)
    }

    func fetchAndUpdateAllFeeds() {
        var count: Int = 1
        rssPublishers.forEach { publisher in
            api.fetchRSS(with: publisher.enteredLink)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { [unowned self] value in
                    switch value {
                    case .finished:
                        fprint("Successfully fetched data for feed", type: .apiResponse)
                    case .failure(let failure):
                        fprint("Error occured while fetching RSS feed. Error: \(failure)", type: .apiCallError, isError: true)
                    }
                    count += 1
                    if count == rssPublishers.count {
                        refreshViews()
                    }
                }, receiveValue: { [unowned self] response in
                    realm.manageData(from: response, enteredLink: publisher.enteredLink)
                })
                .store(in: &cancellables)
        }
    }

    // MARK: - Local queries

    func searchFor(_ searchText: String) -> AnyPublisher<[RSSItemWithInfo], Never> {
        if searchText.isEmpty {
            return fetchFeed()
        } else {
            return Future<[RSSItemWithInfo], Never> { [unowned self] promise in
                let data = realm.performFuzzySearch(with: searchText)
                let arrayFromResults = Array(data)
                promise(.success(arrayFromResults))
            }
            .eraseToAnyPublisher()
        }
    }

    func fetchFeed(withPublisherId id: String? = nil) -> AnyPublisher<[RSSItemWithInfo], Never> {
        return Future<[RSSItemWithInfo], Never> { [unowned self] promise in
            let data = realm.getFeed(withPublisher: id)
            let arrayFromResults = Array(data)
            promise(.success(arrayFromResults))
        }
        .eraseToAnyPublisher()
    }

    func loadHistory() -> AnyPublisher<[RSSItemWithInfo], Never> {
        return Future<[RSSItemWithInfo], Never> { [unowned self] promise in
            let data = realm.getReadItems()
            let arrayFromResults = Array(data)
            promise(.success(arrayFromResults))
        }
        .eraseToAnyPublisher()
    }

    func loadBookmarks() -> AnyPublisher<[RSSItemWithInfo], Never> {
        return Future<[RSSItemWithInfo], Never> { [unowned self] promise in
            let data = realm.getBookmarkedItems()
            let arrayFromResults = Array(data)
            promise(.success(arrayFromResults))
        }
        .eraseToAnyPublisher()
    }

    // MARK: - RSS Actions

    func bookmarkItem(_ item: RealmRSSFeedItem) {
        realm.markAsBookmaked(item)
        updatedItemSubject.send(item)
    }

    func markItemAsRead(_ item: RealmRSSFeedItem) {
        realm.markAsRead(item)
        updatedItemSubject.send(item)
    }

    func removeProvider(with id: String?) {
        guard let id else { return }
        realm.removePublisher(with: id)
        refreshViewsSubject.send()
    }
}
