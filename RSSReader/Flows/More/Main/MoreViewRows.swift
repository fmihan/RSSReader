//
//  MoreViewRows.swift
//  RSSReader
//
//  Created by Fabijan Mihanović on 02.02.2024..
//

import UIKit

enum MoreViewRows: CaseIterable {
    case history
    case favorites

    var icon: UIImage? {
        switch self {
        case .history:
            return UIImage(systemName: "clock.arrow.circlepath")
        case .favorites:
            return UIImage(systemName: "bookmark.fill")
        }
    }

    var tintColor: UIColor? {
        switch self {
        case .history:
            return .gray
        case .favorites:
            return .systemBlue
        }
    }

    var title: String? {
        switch self {
        case .history:
            return "more.actions.history".localize()
        case .favorites:
            return "more.actions.favorites".localize()
        }
    }
}

