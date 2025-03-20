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
    
    var singularUnit: String {
        switch self {
        case .days: return DateConstant.day
        case .weeks: return DateConstant.week
        case .months: return DateConstant.month
        }
    }
    
    var pluralUnit: String {
        switch self {
        case .days: return DateConstant.days
        case .weeks: return DateConstant.weeks
        case .months: return DateConstant.months
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
