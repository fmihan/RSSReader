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
    }

    func loadPublishers() {
        guard let storedPublishers = realm.getPublishers() else { return }
        let publishers = Array(storedPublishers)
        rssPublishers = publishers
        subscibedPortalsSubject.send(publishers)
    }

    // MARK: - Network Calls
    func refreshFeed() {
        isRefreshingSubject.send(true)

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
                dump(response.items?.first)
                realm.manageData(from: response)
                refreshViews()
            })
            .store(in: &cancellables)
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
