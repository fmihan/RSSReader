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
    }

    struct Subjects {
        let reload = PassthroughSubject<Void, Never>()
    }

    weak var coordinator: BaseCoordinator?
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
        Output(reloadPublisher: subjects.reload.eraseToAnyPublisher())
    }

    func observeFeedService() {
        feedService.refreshViewsPublisher
            .subscribe(subjects.reload)
            .store(in: &cancellables)
    }

    func loadStoredFeed() {
        feedService.fetchFeed(withPublisherId: publisherId)
            .sink { [unowned self] storageFeed in
                self.feed = storageFeed
                self.subjects.reload.send()
            }
            .store(in: &cancellables)
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
