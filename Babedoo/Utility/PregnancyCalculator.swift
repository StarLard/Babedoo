//
//  PregnancyCalculator.swift
//  Babedoo
//
//  Created by Caleb Friden on 10/19/22.
//

import Foundation

struct PregnancyCalculator {
    static let daysFromConceptionDateToDueDate: Int = 266
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
    
    /// The upcoming moments, after `date`, at which ``alongValue(from:for:)`` or ``remaingValue(from:for:)`` change.
    ///
    /// "Along" values tick over at whole units from the conception date and "remaining" values at whole units from the
    /// due date, so both sets of boundaries are included. Results are sorted, unique and capped at `limit`.
    func valueChangeDates(after date: Date, for displayComponent: DateDisplayComponent, limit: Int) -> [Date] {
        let component: Calendar.Component
        switch displayComponent {
        case .days: component = .day
        case .weeks: component = .weekOfYear
        case .months: component = .month
        }

        // Calendar differences truncate toward zero, so a value counted from an anchor changes exactly at
        // `anchor + n units` on the side where the anchor is the start date, but only just after `anchor - n units`
        // on the side where it's the end date (at that instant exactly n units still remain). The anchor itself isn't a
        // boundary: the value is 0 on both sides of it.
        var boundaries = Set<Date>()
        for offset in 1...Self.maxBoundaryOffset {
            if let afterConception = calendar.date(byAdding: component, value: offset, to: conceptionDate) {
                boundaries.insert(afterConception)
            }
            if let beforeConception = calendar.date(byAdding: component, value: -offset, to: conceptionDate) {
                boundaries.insert(beforeConception.addingTimeInterval(Self.justAfter))
            }
            if let afterDueDate = calendar.date(byAdding: component, value: offset, to: dueDate) {
                boundaries.insert(afterDueDate)
            }
            if let beforeDueDate = calendar.date(byAdding: component, value: -offset, to: dueDate) {
                boundaries.insert(beforeDueDate.addingTimeInterval(Self.justAfter))
            }
        }

        return Array(boundaries.filter { $0 > date }.sorted().prefix(limit))
    }

    /// Enough unit offsets to cover a full pregnancy (and some overdue time) in days.
    private static let maxBoundaryOffset = 320

    /// How long after a boundary to schedule an update so a count that's truncated toward zero has ticked over.
    private static let justAfter: TimeInterval = 1

    private let calendar = Calendar.current
}
