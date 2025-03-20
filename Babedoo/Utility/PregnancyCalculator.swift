//
//  PregnancyCalculator.swift
//  Babedoo
//
//  Created by Caleb Friden on 10/19/22.
//

import Foundation

struct PregnancyCalculator {
    var dueDate: Date
    var conceptionDate: Date
    
    func progressPercentage(from date: Date) -> Double {
        let timeUntilDueDate = dueDate.timeIntervalSince(conceptionDate)
        guard timeUntilDueDate != 0 else { return 1 }
        let timeFromConception = date.timeIntervalSince(conceptionDate)
        return min(1, timeFromConception / timeUntilDueDate)
    }
    
    func remaingValue(from date: Date, for displayComponent: DateDisplayComponent) -> Int {
        switch displayComponent {
        case .days:
            let components = calendar.dateComponents([.day], from: date, to: dueDate)
            return components.day ?? 0
        case .weeks:
            let components = calendar.dateComponents([.weekOfYear], from: date, to: dueDate)
            return components.weekOfYear ?? 0
        case .months:
            let components = calendar.dateComponents([.month], from: date, to: dueDate)
            return components.month ?? 0
        }
    }
    
    func alongValue(from date: Date, for displayComponent: DateDisplayComponent) -> Int {
        switch displayComponent {
        case .days:
            let components = calendar.dateComponents([.day], from: conceptionDate, to: date)
            return components.day ?? 0
        case .weeks:
            let components = calendar.dateComponents([.weekOfYear], from: conceptionDate, to: date)
            return components.weekOfYear ?? 0
        case .months:
            let components = calendar.dateComponents([.month], from: conceptionDate, to: date)
            return components.month ?? 0
        }
    }
    
    private let calendar = Calendar.current
}
