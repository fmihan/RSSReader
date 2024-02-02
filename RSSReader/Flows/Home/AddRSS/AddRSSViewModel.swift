//
//  AddRSSViewModel.swift
//  RSSReader
//
//  Created by Fabijan Mihanović on 02.02.2024..
//

import FeedKit
import Combine
import Foundation

class AddRSSViewModel: HasRSSReaderApi, HasFeedService {

    struct Input {
        let searchTextPublisher: AnyPublisher<String?, Never>
    }

    struct Subjects {
        let reload = PassthroughSubject<Void, Never>()
        let noRSSFeed = PassthroughSubject<Bool, Never>()
        let sourceAdded = PassthroughSubject<Void, Never>()
    }

    struct Output {
        let reloadPublisher: AnyPublisher<Void, Never>
        let noRSSFeedPublisher: AnyPublisher<Bool, Never>
        let sourceAdded: AnyPublisher<Void, Never>
    }

    weak var homeCoordinator: HomeCoordinator?

    var api: RSSReaderApiProtocol
    var feedService: FeedServiceProtocol

    var rssFeed: RSSFeed?
    var lookedUrl: String?
    var subjects = Subjects()
    var cancellables = Set<AnyCancellable>()

    init(
        api: RSSReaderApiProtocol,
        feedService: FeedServiceProtocol
    ) {
        self.api = api
        self.feedService = feedService
    }

    func transform(input: Input) -> Output {
        observeSearchText(input.searchTextPublisher)

        return Output(
            reloadPublisher: subjects.reload.eraseToAnyPublisher(),
            noRSSFeedPublisher: subjects.noRSSFeed.eraseToAnyPublisher(),
            sourceAdded: subjects.sourceAdded.eraseToAnyPublisher()
        )
    }

    func observeSearchText(_ publisher: AnyPublisher<String?, Never>) {
        publisher
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .sink { [unowned self] value in
                guard let url = preapendHTTPSchemeIfNeeded(value) else {
                    removeData()
                    return
                }
                loadRSSFeed(via: url)
            }
            .store(in: &cancellables)
    }

    func loadRSSFeed(via url: String?) {
        guard let url else { return }
        api.fetchRSS(with: url)
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] value in
                switch value {
                case .finished:
                    fprint("Successfully fetched RSS feed data", type: .apiResponse)
                    subjects.noRSSFeed.send(false)
                case .failure(let error):
                    fprint("Error occured while fething RSS feed data. Error: \(error)", type: .apiResponse)
                    removeData()
                    subjects.noRSSFeed.send(true)
                }
            } receiveValue: { value in
                self.rssFeed = value
                self.lookedUrl = url
                self.subjects.reload.send()
            }
            .store(in: &cancellables)

    }

    func removeData() {
        rssFeed = nil
        lookedUrl = nil
        subjects.reload.send()
    }

    func add() {
        guard let lookedUrl else { return }
        feedService.addNewFeed(with: lookedUrl)
        subjects.sourceAdded.send()
    }

    private func preapendHTTPSchemeIfNeeded(_ urlString: String?) -> String? {
        guard let urlString = urlString else { return nil }

        if urlString.lowercased().hasPrefix("https://") || urlString.lowercased().hasPrefix("http://") {
            return urlString
        } else {
            return "https://" + urlString
        }
    }
}

extension AddRSSViewModel {

    func numberOfSections() -> Int {
        guard let rssFeed else { return 0 }
        var count = 1
        if let items = rssFeed.items, items.count > 0 {
            count += 1
        }
        return count
    }

    func numberOfItems(inSection section: Int) -> Int {
        if section == 0 {
            return rssFeed == nil ? 0 : 1
        } else if let items = rssFeed?.items {
            return items.count
        } else {
            return 0
        }
    }

    func item(for row: Int) -> RSSFeedItem? {
        rssFeed?.items?[row]
    }
}
