//
//  HomeViewModel.swift
//  RSSReader
//
//  Created by Fabijan Mihanović on 31.01.2024..
//

import Combine
import Foundation

class HomeViewModel: HasFeedService {

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

    init(feedService: FeedServiceProtocol) {
        self.feedService = feedService
        observeFeedService()
    }

    func transform() -> Output {
        Output(reloadPublisher: subjects.reload.eraseToAnyPublisher())
    }

    func observeFeedService() {
        feedService.feedPublisherPublisher
            .sink { [unowned self] homepageFeed in
                self.feed = homepageFeed
                self.subjects.reload.send()
            }
            .store(in: &cancellables)

        feedService.addNewFeed(with: "https://net.hr/feed")
    }

    func reload() {
        feedService.fetchFeed()
    }

    func search(text: String) {
        feedService.searchFor(text)
    }
}

extension HomeViewModel {

    func numberOfItems() -> Int {
        feed.count
    }

    func itemAt(row: Int) -> RSSItemWithInfo {
        feed[row]
    }

}
