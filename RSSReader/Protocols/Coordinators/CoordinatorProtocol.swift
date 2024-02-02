//
//  CoordinatorProtocol.swift
//  RSSReader
//
//  Created by Fabijan Mihanović on 26.01.2024..
//

import Foundation

protocol CoordinatorProtocol: AnyObject {
    var childCoordinators: [CoordinatorProtocol] { get set }
    var navigationController: NavigationViewController { get set }
    func childDidFinish(_ child: CoordinatorProtocol?)

    func start()
}

extension CoordinatorProtocol {
    func childDidFinish(_ child: CoordinatorProtocol?) {
        childCoordinators.removeAll(where: { $0 === child })
    }
}

