//
//  DateConstants.swift
//  Babedoo
//
//  Created by Caleb Friden on 10/19/22.
//

import Foundation

enum DateConstant {
    static func daysAbbreviation(_ days: Int) -> String {
        String(localized: "\(days) dy(s)", comment: "Label for an abbreviated day unit")
    }

    static func weeksAbbreviation(_ weeks: Int) -> String {
        String(localized: "\(weeks) wk(s)", comment: "Label for an abbreviated week unit")
    }

    static func monthsAbbreviation(_ months: Int) -> String {
        String(localized: "\(months) mo(s)", comment: "Label for an abbreviated month unit")
    }
}
