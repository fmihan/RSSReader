//
//  SearchViewModel.swift
//  RSSReader
//
//  Created by Fabijan Mihanović on 02.02.2024..
//

import UIKit
import Combine

class SearchViewModel: HasFeedService {

    struct Output {
        let reloadPublisher: AnyPublisher<Void, Never>
        let reloadRowPublisher: AnyPublisher<IndexPath, Never>
    }

    struct Subjects {
        let reload = PassthroughSubject<Void, Never>()
        let reloadRow = PassthroughSubject<IndexPath, Never>()
    }

    weak var coordinator: SearchCoordinator?
    var cancellables = Set<AnyCancellable>()

    var feedService: FeedServiceProtocol
    var feed: [RSSItemWithInfo] = []
    var subjects = Subjects()

    init(feedService: FeedServiceProtocol) {
        self.feedService = feedService

        observeFeedService()
        loadStoredFeed()
    }

    func transform() -> Output {
        Output(
            reloadPublisher: subjects.reload.eraseToAnyPublisher(),
            reloadRowPublisher: subjects.reloadRow.eraseToAnyPublisher()
        )
    }

    func searchForFeed(with searchText: String) {
        if searchText.isEmpty {
            loadStoredFeed()
        } else {
            queryForFeed(with: searchText)
        }
    }

    func observeFeedService() {
        feedService.refreshViewsPublisher
            .sink(receiveValue: { [unowned self] _ in
                loadStoredFeed()
                subjects.reload.send()
            })
            .store(in: &cancellables)

        feedService.updatedItemPublisher
            .sink { [unowned self] value in
                manageUpdatedItem(value)
            }
            .store(in: &cancellables)
    }

    func manageUpdatedItem(_ item: RealmRSSFeedItem) {
        guard let index = feed.firstIndex(where: { $0.item?.id == item.id }) else { return }
        feed[index].item = item
        subjects.reloadRow.send(IndexPath(row: index, section: 0))
    }

    func loadStoredFeed() {
        feedService.fetchFeed(withPublisherId: nil)
            .sink { [unowned self] storageFeed in
                self.feed = storageFeed
                self.subjects.reload.send()
            }
            .store(in: &cancellables)
    }

    func queryForFeed(with text: String) {
        feedService.searchFor(text)
            .sink { [unowned self] storageFeed in
                self.feed = storageFeed
                self.subjects.reload.send()
            }
            .store(in: &cancellables)
    }

    func actions(for item: RealmRSSFeedItem?) {
        guard let item else { return }
        coordinator?.showActions(for: item)
    }

    func bookmark(for item: RealmRSSFeedItem?) {
        guard let item else { return }
        feedService.bookmarkItem(item)
    }

    func openWeb(for item: RealmRSSFeedItem?) {
        guard let item else { return }
        feedService.markItemAsRead(item)
        coordinator?.pushToWebView(url: item.link)
    }
}

extension SearchViewModel {

    func numberOfItems() -> Int {
        feed.count
    }

    func itemAt(row: Int) -> RSSItemWithInfo {
        feed[row]
    }

}
