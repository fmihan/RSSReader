//
//  FPrint.swift
//  RSSReader
//
//  Created by Fabijan Mihanović on 26.01.2024..
//

import Foundation

enum FPrintType: CaseIterable {
    case general
    case apiCall
    case apiResponse
    case apiCallError
    case rssDecodingError
    case rssDecodingSuccess
    case realm
    case realmSavingError
    case network

    var emoji: String? {
        switch self {
        case .general:
            return nil
        case .apiCall:
            return "🌐"
        case .apiResponse:
            return "🔽"
        case .apiCallError:
            return "🌐❌"
        case .rssDecodingError:
            return "🚮"
        case .rssDecodingSuccess:
            return "🤙"
        case .realm:
            return "🗄️"
        case .realmSavingError:
            return "🗄️❌"
        case .network:
            return "📡"
        }
    }
}

let enabledFprints: [FPrintType] = FPrintType.allCases

func fprint(_ items: Any..., type: FPrintType = .general, isError: Bool = false ) {
    guard enabledFprints.contains(type) else { return }
    let output = items.map { "\($0)" }.joined(separator: " ")
    if let emoji = type.emoji {
        Swift.print("\(emoji)\(isError ? " ❌" : "") - \(output)")
    } else {
        Swift.print("\(isError ? "❌ " : "")\(output)")
    }
}

