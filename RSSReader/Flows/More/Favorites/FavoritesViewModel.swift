//
//  FavoritesViewModel.swift
//  RSSReader
//
//  Created by Fabijan Mihanović on 02.02.2024..
//

import UIKit
import Combine

class FavoritesViewModel: HasFeedService {

    struct Output {
        let reloadPublisher: AnyPublisher<Void, Never>
        let reloadRowPublisher: AnyPublisher<IndexPath, Never>
        let noItemsPublisher: AnyPublisher<Bool, Never>
    }

    struct Subjects {
        let reload = PassthroughSubject<Void, Never>()
        let reloadRow = PassthroughSubject<IndexPath, Never>()
        let noItems = CurrentValueSubject<Bool, Never>(false)
    }

    weak var coordinator: MoreCoordinator?
    var cancellables = Set<AnyCancellable>()

    var feedService: FeedServiceProtocol
    var feed: [RSSItemWithInfo] = []
    var subjects = Subjects()

    init(feedService: FeedServiceProtocol) {
        self.feedService = feedService

        observeFeedService()
        loadFavorites()
    }

    func transform() -> Output {
        Output(
            reloadPublisher: subjects.reload.eraseToAnyPublisher(),
            reloadRowPublisher: subjects.reloadRow.eraseToAnyPublisher(),
            noItemsPublisher: subjects.noItems.eraseToAnyPublisher()
        )
    }

    func observeFeedService() {
        feedService.refreshViewsPublisher
            .sink(receiveValue: { [unowned self] _ in
                loadFavorites()
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

    func loadFavorites() {
        feedService.loadBookmarks()
            .sink { [unowned self] history in
                feed = history
                subjects.reload.send()
                subjects.noItems.send(history.isEmpty)
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
        coordinator?.pushToWebView(url: item.link)
    }
}

extension FavoritesViewModel {

    func numberOfItems() -> Int {
        feed.count
    }

    func itemAt(row: Int) -> RSSItemWithInfo {
        feed[row]
    }

}


