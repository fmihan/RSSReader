//
//  MainHomepageViewModel.swift
//  RSSReader
//
//  Created by Fabijan Mihanović on 02.02.2024..
//

import Combine
import Foundation

class MainHomepageViewModel: HasFeedService {

    struct Output {
        let reloadPublisher: AnyPublisher<Void, Never>
        let noResultsPublisher: AnyPublisher<Bool, Never>
    }

    struct Subjects {
        let reload = PassthroughSubject<Void, Never>()
        let noResults = CurrentValueSubject<Bool, Never>(false)
    }

    var subjects = Subjects()
    var publishers: [RealmRSSFeed] = []
    var feedService: FeedServiceProtocol
    var cancellables = Set<AnyCancellable>()

    init(feedService: FeedServiceProtocol) {
        self.feedService = feedService
        observeFeedService()
    }

    func transform() -> Output {
        Output(
            reloadPublisher: subjects.reload.eraseToAnyPublisher(),
            noResultsPublisher: subjects.noResults.eraseToAnyPublisher()
        )
    }

    func observeFeedService() {
        feedService.subscibedPortalsPublisher
            .sink { [unowned self] portals in
                publishers = portals
                subjects.reload.send()
                subjects.noResults.send(portals.isEmpty)
            }
            .store(in: &cancellables)
    }

    func addFeed() {
        
    }
}

extension MainHomepageViewModel {

    func numberOfItems() -> Int {
        return hasMixedFeed() ? publishers.count + 1 : 1
    }

    func pageTitle(for itemIndex: Int) -> String {
        guard publishers.count > 0 else { return "" }
        
        if hasMixedFeed() {
            return itemIndex == 0 ? "home.mixed.feed".localize() : (publishers[itemIndex - 1].title ?? "")
        } else {
            return (publishers[itemIndex].title ?? "")
        }
    }

    func hasMixedFeed() -> Bool {
        publishers.count > 1
    }

    func getPublisherId(for itemIndex: Int) -> String {
        guard hasMixedFeed() else { return "" }
        return publishers[itemIndex - 1].id
    }

}
