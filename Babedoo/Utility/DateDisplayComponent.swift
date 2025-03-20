//
//  DateDisplayComponent.swift
//  Babedoo
//
//  Created by Caleb Friden on 10/19/22.
//

import Foundation

enum DateDisplayComponent {
    case days
    case weeks
    case months
    
    func unit(for quantity: Int) -> String {
        switch self {
        case .days: return DateConstant.days(quantity)
        case .weeks: return DateConstant.weeks(quantity)
        case .months: return DateConstant.months(quantity)
        }
    }

    func abbreviatedUnit(for quantity: Int) -> String {
        switch self {
        case .days: return DateConstant.daysAbbreviation(quantity)
        case .weeks: return DateConstant.weeksAbbreviation(quantity)
        case .months: return DateConstant.monthsAbbreviation(quantity)
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
