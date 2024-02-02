//
//  APIError.swift
//  RSSReader
//
//  Created by Fabijan Mihanović on 26.01.2024..
//

import Foundation

enum APIError: Error {
    case invalidURL
    case serverError
    case clientError(code: Int)
    case serverApiError
    case creatingRequest
    case failedToDecode
    case unknownError

    var description: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .serverError:
            return "Server Error"
        case .clientError(let code):
            return "Client error, server code \(code))"
        case .serverApiError:
            return "Server API Error"
        case .creatingRequest:
            return "Error creating Request"
        case .failedToDecode:
            return "Failed to decode"
        case .unknownError:
            return "Unknown error occured"
        }
    }
}



