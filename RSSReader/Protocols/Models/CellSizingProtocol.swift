//
//  CellSizingProtocol.swift
//  RSSReader
//
//  Created by Fabijan Mihanović on 02.02.2024..
//

import Foundation

enum CellSize {
    case small
    case medium
    case large
}

protocol SizingCellProtocol: Imaginable {
    var title: String? { get }
}

extension SizingCellProtocol {
    var size: CellSize {
        if hasNoPicture {
            return .small
        }

        guard let title else { return .small }
        return title.count > 100 ? .medium : .large
    }
}
