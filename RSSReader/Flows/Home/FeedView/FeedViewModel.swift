//
//  FeedViewModel.swift
//  RSSReader
//
//  Created by Fabijan Mihanović on 31.01.2024..
//

import Combine
import Foundation

class FeedViewModel: HasFeedService {

    struct Output {
        let reloadPublisher: AnyPublisher<Void, Never>
        let reloadRowPublisher: AnyPublisher<IndexPath, Never>
    }

    struct Subjects {
        let reload = PassthroughSubject<Void, Never>()
        let reloadRow = PassthroughSubject<IndexPath, Never>()
    }

    weak var coordinator: HomeCoordinator?
    var cancellables = Set<AnyCancellable>()

    var feedService: FeedServiceProtocol
    var feed: [RSSItemWithInfo] = []
    var subjects = Subjects()

    var publisherId: String?

    init(feedService: FeedServiceProtocol, specifiedProviderId: String? = nil) {
        self.feedService = feedService
        self.publisherId = specifiedProviderId

        observeFeedService()
        loadStoredFeed()
    }

    func transform() -> Output {
        Output(
            reloadPublisher: subjects.reload.eraseToAnyPublisher(),
            reloadRowPublisher: subjects.reloadRow.eraseToAnyPublisher()
        )
    }

    func observeFeedService() {
        feedService.refreshViewsPublisher
            .subscribe(subjects.reload)
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
        feedService.fetchFeed(withPublisherId: publisherId)
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
}

extension FeedViewModel {

    func numberOfItems() -> Int {
        feed.count
    }

    func itemAt(row: Int) -> RSSItemWithInfo {
        feed[row]
    }

}
