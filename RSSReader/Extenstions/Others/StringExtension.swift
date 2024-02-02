//
//  StringExtension.swift
//  RSSReader
//
//  Created by Fabijan Mihanović on 26.01.2024..
//

import Foundation

extension String {
    func localize() -> String {
        return NSLocalizedString(self, comment: "")
    }

    func extractSource() -> String? {
        let htmlString = self

        do {
            let pattern = #"src=\"([^"]+)\""#
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let range = NSRange(htmlString.startIndex..<htmlString.endIndex, in: htmlString)

            if let match = regex.firstMatch(in: htmlString, options: [], range: range) {
                let srcRange = Range(match.range(at: 1), in: htmlString)!
                let src = String(htmlString[srcRange])
                return src
            } else {
                return nil
            }
        } catch {
            print("Error extracting URL: \(error)")
            return nil
        }

    }
}
