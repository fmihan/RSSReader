//
//  RSSReaderApi.swift
//  RSSReader
//
//  Created by Fabijan Mihanović on 31.01.2024..
//

import FeedKit
import Combine
import Foundation

class RSSReaderApi: NetworkingService, RSSReaderApiProtocol {

    func fetchRSS(with url: String) -> AnyPublisher<RSSFeed, Error> {
        callAPI(url: URL(string: url))
    }

}
