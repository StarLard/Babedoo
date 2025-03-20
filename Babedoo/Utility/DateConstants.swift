//
//  DateConstants.swift
//  Babedoo
//
//  Created by Caleb Friden on 10/19/22.
//

import Foundation

enum DateConstant {
    static func days(_ days: Int) -> String {
        String(localized: "\(days) day(s)", comment: "Label for day unit")
    }

    static func weeks(_ weeks: Int) -> String {
        String(localized: "\(weeks) week(s)", comment: "Label for week unit")
    }

    static func months(_ months: Int) -> String {
        String(localized: "\(months) month(s)", comment: "Label for month unit")
    }

    static func daysAbbreviation(_ days: Int) -> String {
        String(localized: "\(days) day(s)", comment: "Label for an abbreviated day unit")
    }

    static func weeksAbbreviation(_ weeks: Int) -> String {
        String(localized: "\(weeks) wk(s)", comment: "Label for an abbreviated week unit")
    }

    static func monthsAbbreviation(_ months: Int) -> String {
        String(localized: "\(months) mo(s)", comment: "Label for an abbreviated month unit")
    }
}
