//
//  DateUtils.swift
//  RSSReader
//
//  Created by Fabijan Mihanović on 26.01.2024..
//

import Foundation

class DateUtils {

    static func formatDate(_ dateString: String, withDateFormat providedFormat: String = "EE, dd MMM yyyy HH:mm:ss Z") -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = providedFormat
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")

        guard let date = dateFormatter.date(from: dateString) else {
            return nil
        }

        let calendar = Calendar.current

        let dateFormatterOutput = DateFormatter()
        dateFormatterOutput.locale = Locale.current
        dateFormatterOutput.timeStyle = .short

        if calendar.isDateInToday(date) {
            dateFormatterOutput.dateFormat = "'\("today.at".localize())' HH:mm"
        } else if calendar.isDateInYesterday(date) {
            dateFormatterOutput.dateFormat = "'\("yesterday.at".localize())' HH:mm"
        } else {
            dateFormatterOutput.dateFormat = "dd.MM.yyyy. '\("at".localize())' HH:mm"
        }

        return dateFormatterOutput.string(from: date)
    }

    static func getDateFrom(_ dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")

        guard let date = dateFormatter.date(from: dateString) else {
            return nil
        }

        return date
    }

    static func formatDate(_ date: Date?, withDateFormat providedFormat: String = "EE, dd MMM yyyy HH:mm:ss Z") -> String? {
        guard let date else { return nil }
        let calendar = Calendar.current

        let dateFormatterOutput = DateFormatter()
        dateFormatterOutput.locale = Locale.current
        dateFormatterOutput.timeStyle = .short

        if calendar.isDateInToday(date) {
            dateFormatterOutput.dateFormat = "'\("today.at".localize())' HH:mm"
        } else if calendar.isDateInYesterday(date) {
            dateFormatterOutput.dateFormat = "'\("yesterday.at".localize())' HH:mm"
        } else {
            dateFormatterOutput.dateFormat = "dd.MM.yyyy. '\("at".localize())' HH:mm"
        }

        return dateFormatterOutput.string(from: date)
    }

    static func timeAgo(from date: Date?) -> String? {
        let calendar = Calendar.current
        guard let minuteAgo = calendar.date(byAdding: .minute, value: -1, to: Date()),
              let hourAgo = calendar.date(byAdding: .hour, value: -1, to: Date()),
              let dayAgo = calendar.date(byAdding: .day, value: -1, to: Date()),
              let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date()),
              let monthAgo = calendar.date(byAdding: .month, value: -1, to: Date()),
              let yearAgo = calendar.date(byAdding: .year, value: -1, to: Date())
        else { return nil }

        guard let date else { return nil }

        if minuteAgo < date {
            let diff = Calendar.current.dateComponents([.second], from: date, to: Date()).second ?? 0
            return "\(diff) \("date.time.s.ago".localize())"
        } else if hourAgo < date {
            let diff = Calendar.current.dateComponents([.minute], from: date, to: Date()).minute ?? 0
            return "\(diff) \("date.time.m.ago".localize())"
        } else if dayAgo < date {
            let diff = Calendar.current.dateComponents([.hour], from: date, to: Date()).hour ?? 0
            return "\(diff) \("date.time.h.ago".localize())"
        } else if weekAgo < date {
            let diff = Calendar.current.dateComponents([.day], from: date, to: Date()).day ?? 0
            return diff == 1 ? "\(diff) \("date.time.day.ago".localize())" : "\(diff) \("date.time.days.ago".localize())"
        } else if monthAgo < date {
            let diff = Calendar.current.dateComponents([.weekOfYear], from: date, to: Date()).weekOfYear ?? 0
            return diff == 1 ? "\(diff) \("date.time.week.ago".localize())" : "\(diff) \("date.time.weeks.ago".localize())"
        } else if yearAgo < date {
            let diff = Calendar.current.dateComponents([.month], from: date, to: Date()).month ?? 0
            return diff == 1 ? "\(diff) \("date.time.month.ago".localize())" : "\(diff) \("date.time.months.ago".localize())"
        }
        let diff = Calendar.current.dateComponents([.year], from: date, to: Date()).year ?? 0
        return diff == 1 ? "\(diff) \("date.time.year.ago".localize())" : "\(diff) \("date.time.years.ago".localize())"
    }

}

