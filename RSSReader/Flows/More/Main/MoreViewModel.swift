//
//  MoreViewModel.swift
//  RSSReader
//
//  Created by Fabijan Mihanović on 02.02.2024..
//

import Combine
import Foundation

class MoreViewModel {

    struct Output {
        var reloadPublisher: AnyPublisher<Void, Never>
    }

    struct Subjects {
        var reload = PassthroughSubject<Void, Never>()
    }

    weak var coordinator: MoreCoordinator?

    var subjects = Subjects()
    var rows: [MoreViewRows] = MoreViewRows.allCases

    init() {
        subjects.reload.send()
    }

    func transform() -> Output {
        Output(reloadPublisher: subjects.reload.eraseToAnyPublisher())
    }

    func action(_ action: MoreViewRows) {
        switch action {
        case .history:
            coordinator?.history()
        case .favorites:
            coordinator?.favorites()
        }
    }
}

extension MoreViewModel {
    func numberOfRows() -> Int {
        rows.count
    }

    func row(for index: Int) -> MoreViewRows {
        rows[index]
    }
}
