//
//  NetworkingService.swift
//  RSSReader
//
//  Created by Fabijan Mihanović on 26.01.2024..
//

import Combine
import FeedKit
import Foundation

class NetworkingService {

    lazy var session: URLSession = {
        .init(configuration: .default, delegate: nil, delegateQueue: nil)
    }()

    func callAPI(url: URL?, method: HTTPMethod = .get) -> AnyPublisher<RSSFeed, Error> {
        return Future<RSSFeed, Error> { promise in
            Task {
                do {
                    let dataObject = try await self.performRequest(with: url, method: method)
                    promise(.success(dataObject))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }


    private func performRequest(with url: URL?, method: HTTPMethod) async throws -> RSSFeed {
        guard let url else { throw APIError.invalidURL }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else { throw APIError.failedToDecode }

        switch httpResponse.statusCode {
        case 200...299:

            switch FeedParser(data: data).parse() {
            case .success(let success):
                guard let rss = success.rssFeed else { throw APIError.failedToDecode}
                return rss
            case .failure(let failure):
                print(failure)
                throw APIError.failedToDecode
            }

        case 400...499:
            throw APIError.clientError(code: httpResponse.statusCode)
        case 500...599:
            throw APIError.serverError
        default:
            throw APIError.unknownError
        }
    }
}

