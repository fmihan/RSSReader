//
//  ReusableViewProtocol.swift
//  RSSReader
//
//  Created by Fabijan Mihanović on 26.01.2024..
//

import UIKit

protocol ReusableView: AnyObject {
    static var defaultReuseIdentifier: String { get }
    static var defaultKind: String { get }
}

extension ReusableView where Self: UIView {
    static var defaultReuseIdentifier: String {
        return NSStringFromClass(self)
    }

    static var defaultKind: String {
        return "kind.\(NSStringFromClass(self))"
    }
}
