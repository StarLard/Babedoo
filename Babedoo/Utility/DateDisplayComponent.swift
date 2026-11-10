//
//  DateDisplayComponent.swift
//  Babedoo
//
//  Created by Caleb Friden on 10/19/22.
//

import Foundation

/// Whether a value counts the time since conception or the time until the due date.
enum TimeDirection {
    case along
    case remaining
}

enum DateDisplayComponent {
    case days
    case weeks
    case months
    
    func abbreviatedUnit(for quantity: Int) -> String {
        switch self {
        case .days: return DateConstant.daysAbbreviation(quantity)
        case .weeks: return DateConstant.weeksAbbreviation(quantity)
        case .months: return DateConstant.monthsAbbreviation(quantity)
        }
    }

    /// The unit and direction shown beside a large number, e.g. "weeks\nalong".
    ///
    /// Each unit and direction has its own localized string so translations can make the
    /// direction agree with the unit. The quantity only selects the plural form; the number
    /// itself is displayed separately and isn't part of the result.
    func caption(for quantity: Int, direction: TimeDirection) -> String {
        switch (self, direction) {
        case (.days, .along):
            return String(localized: "\(quantity) days\nalong", comment: "Two-line caption beside a large number of days since conception. The number is displayed separately, so don't include it; it only selects the plural form.")
        case (.days, .remaining):
            return String(localized: "\(quantity) days\nto go", comment: "Two-line caption beside a large number of days until the due date. The number is displayed separately, so don't include it; it only selects the plural form.")
        case (.weeks, .along):
            return String(localized: "\(quantity) weeks\nalong", comment: "Two-line caption beside a large number of weeks since conception. The number is displayed separately, so don't include it; it only selects the plural form.")
        case (.weeks, .remaining):
            return String(localized: "\(quantity) weeks\nto go", comment: "Two-line caption beside a large number of weeks until the due date. The number is displayed separately, so don't include it; it only selects the plural form.")
        case (.months, .along):
            return String(localized: "\(quantity) months\nalong", comment: "Two-line caption beside a large number of months since conception. The number is displayed separately, so don't include it; it only selects the plural form.")
        case (.months, .remaining):
            return String(localized: "\(quantity) months\nto go", comment: "Two-line caption beside a large number of months until the due date. The number is displayed separately, so don't include it; it only selects the plural form.")
        }
    }

    /// A complete phrase including the number, e.g. "12 weeks along".
    func phrase(for quantity: Int, direction: TimeDirection) -> String {
        switch (self, direction) {
        case (.days, .along):
            return String(localized: "\(quantity) days along", comment: "Number of days since conception, e.g. \"12 days along\"")
        case (.days, .remaining):
            return String(localized: "\(quantity) days to go", comment: "Number of days until the due date, e.g. \"12 days to go\"")
        case (.weeks, .along):
            return String(localized: "\(quantity) weeks along", comment: "Number of weeks since conception, e.g. \"12 weeks along\"")
        case (.weeks, .remaining):
            return String(localized: "\(quantity) weeks to go", comment: "Number of weeks until the due date, e.g. \"12 weeks to go\"")
        case (.months, .along):
            return String(localized: "\(quantity) months along", comment: "Number of months since conception, e.g. \"3 months along\"")
        case (.months, .remaining):
            return String(localized: "\(quantity) months to go", comment: "Number of months until the due date, e.g. \"3 months to go\"")
        }
    }

    var next: Self {
        switch self {
        case .days: return .weeks
        case .weeks: return .months
        case .months: return .days
        }
    }
}
