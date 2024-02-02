//
//  TabBarPage.swift
//  RSSReader
//
//  Created by Fabijan Mihanović on 02.02.2024..
//

import UIKit

enum TabBarPage: CaseIterable {
    case home
    case search
    case more

    init?(index: Int) {
        switch index {
        case 0:
            self = .home
        case 1:
            self = .search
        case 2:
            self = .more
        default: return nil
        }
    }

    var title: String {
        switch self {
        case .home:
            return "navigation.home".localize()
        case .search:
            return "navigation.search".localize()
        case .more:
            return "navigation.more".localize()
        }
    }

    var icon: UIImage? {
        switch self {
        case .home:
            return UIImage(systemName: "house")
        case .search:
            return UIImage(systemName: "magnifyingglass")
        case .more:
            return UIImage(systemName: "ellipsis")
        }
    }

    var pageOrder: Int {
        switch self {
        case .home:
            return 0
        case .search:
            return 1
        case .more:
            return 2
        }
    }
}
