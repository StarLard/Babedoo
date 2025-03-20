//
//  Provider.swift
//  Babedoo WidgetsExtension
//
//  Created by Caleb Friden on 10/19/22.
//

import SwiftUI
import WidgetKit
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        let configuration = ConfigurationIntent()
        let displayComponent = DateDisplayComponent(timeUnit: configuration.timeUnit)
        let dueDate = UserDefaults.appGroup.dueDate ?? calendar.date(byAdding: .day, value: 280, to: .now) ?? .now
        let conceptionDate = UserDefaults.appGroup.conceptionDate ?? .now
        return SimpleEntry(date: Date(), dueDate: dueDate, conceptionDate: conceptionDate, displayComponent: displayComponent, configuration: configuration)
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let displayComponent = DateDisplayComponent(timeUnit: configuration.timeUnit)
        let dueDate = UserDefaults.appGroup.dueDate ?? calendar.date(byAdding: .day, value: 280, to: .now) ?? .now
        let conceptionDate = UserDefaults.appGroup.conceptionDate ?? .now
        let entry = SimpleEntry(date: Date(), dueDate: dueDate, conceptionDate: conceptionDate, displayComponent: displayComponent, configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        let displayComponent = DateDisplayComponent(timeUnit: configuration.timeUnit)
        var entries: [SimpleEntry] = []
        let currentDate = Date()
        
        guard let dueDate = UserDefaults.appGroup.dueDate else {
            let mockDueDate = calendar.date(byAdding: .day, value: 280, to: currentDate) ?? currentDate
            let timeline = Timeline(entries: [SimpleEntry(date: currentDate, dueDate: mockDueDate, conceptionDate: currentDate, displayComponent: displayComponent, configuration: configuration)], policy: .never)
            completion(timeline)
            return
        }
        
        guard let conceptionDate = UserDefaults.appGroup.conceptionDate else {
            let mockConceptionDate = calendar.date(byAdding: .day, value: -280, to: dueDate) ?? currentDate
            let timeline = Timeline(entries: [SimpleEntry(date: currentDate, dueDate: dueDate, conceptionDate: mockConceptionDate, displayComponent: displayComponent, configuration: configuration)], policy: .never)
            completion(timeline)
            return
        }

        // Refresh widget once per date interval.
        let unitsRemaining: Int
        switch displayComponent {
        case .days:
            let components = calendar.dateComponents([.day], from: currentDate, to: dueDate)
            unitsRemaining = components.day ?? 0
        case .weeks:
            let components = calendar.dateComponents([.weekOfYear], from: currentDate, to: dueDate)
            unitsRemaining = components.weekOfYear ?? 0
        case .months:
            let components = calendar.dateComponents([.month], from: currentDate, to: dueDate)
            unitsRemaining = components.month ?? 0
        }
        
        for unitOffset in 0..<unitsRemaining {
            let entryDate: Date?
            switch displayComponent {
            case .days:
                entryDate = calendar.date(byAdding: .day, value: unitOffset, to: currentDate)
            case .weeks:
                entryDate = calendar.date(byAdding: .weekOfYear, value: unitOffset, to: currentDate)
            case .months:
                entryDate = calendar.date(byAdding: .month, value: unitOffset, to: currentDate)
            }
            guard let entryDate = entryDate else { continue }
            let entry = SimpleEntry(date: entryDate, dueDate: dueDate, conceptionDate: conceptionDate, displayComponent: displayComponent, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
    
    let calendar = Calendar.current
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let dueDate: Date
    let conceptionDate: Date
    let displayComponent: DateDisplayComponent
    let configuration: ConfigurationIntent
}

extension DateDisplayComponent {
    init(timeUnit: TimeUnit) {
        switch timeUnit {
        case .days: self = .days
        case .weeks, .unknown: self = .weeks
        case .months: self = .months
        }
    }
}
