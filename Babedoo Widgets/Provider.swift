//
//  Provider.swift
//  Babedoo WidgetsExtension
//
//  Created by Caleb Friden on 10/19/22.
//

import SwiftUI
import StarLardCoreKit
import WidgetKit
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        let configuration = ConfigurationIntent()
        let displayComponent = DateDisplayComponent(timeUnit: configuration.timeUnit)
        let dueDate = UserDefaults.appGroup.dueDate ?? calendar.date(byAdding: .day, value: PregnancyCalculator.daysFromConceptionDateToDueDate, to: .current) ?? .current
        let conceptionDate = UserDefaults.appGroup.conceptionDate ?? .current
        return SimpleEntry(date: Date.current, dueDate: dueDate, conceptionDate: conceptionDate, displayComponent: displayComponent, configuration: configuration)
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let displayComponent = DateDisplayComponent(timeUnit: configuration.timeUnit)
        let dueDate = UserDefaults.appGroup.dueDate ?? calendar.date(byAdding: .day, value: PregnancyCalculator.daysFromConceptionDateToDueDate, to: .current) ?? .current
        let conceptionDate = UserDefaults.appGroup.conceptionDate ?? .current
        let entry = SimpleEntry(date: Date.current, dueDate: dueDate, conceptionDate: conceptionDate, displayComponent: displayComponent, configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        let displayComponent = DateDisplayComponent(timeUnit: configuration.timeUnit)
        var entries: [SimpleEntry] = []
        let currentDate = Date.current
        
        guard let dueDate = UserDefaults.appGroup.dueDate else {
            let mockDueDate = calendar.date(byAdding: .day, value: PregnancyCalculator.daysFromConceptionDateToDueDate, to: currentDate) ?? currentDate
            let timeline = Timeline(entries: [SimpleEntry(date: currentDate, dueDate: mockDueDate, conceptionDate: currentDate, displayComponent: displayComponent, configuration: configuration)], policy: .never)
            completion(timeline)
            return
        }
        
        guard let conceptionDate = UserDefaults.appGroup.conceptionDate else {
            let mockConceptionDate = calendar.date(byAdding: .day, value: -PregnancyCalculator.daysFromConceptionDateToDueDate, to: dueDate) ?? currentDate
            let timeline = Timeline(entries: [SimpleEntry(date: currentDate, dueDate: dueDate, conceptionDate: mockConceptionDate, displayComponent: displayComponent, configuration: configuration)], policy: .never)
            completion(timeline)
            return
        }

        // The displayed value changes at whole-unit boundaries measured from the conception date
        // ("along") and from the due date ("to go") — not from when this timeline was generated.
        // Schedule an entry exactly at each of those boundaries so the widget flips on time.
        let upcoming = PregnancyCalculator(dueDate: dueDate, conceptionDate: conceptionDate)
            .valueChangeDates(after: currentDate, for: displayComponent, limit: Self.maxEntries)

        entries.append(SimpleEntry(date: currentDate, dueDate: dueDate, conceptionDate: conceptionDate, displayComponent: displayComponent, configuration: configuration))
        for entryDate in upcoming {
            entries.append(SimpleEntry(date: entryDate, dueDate: dueDate, conceptionDate: conceptionDate, displayComponent: displayComponent, configuration: configuration))
        }

        // Ask for a fresh timeline after the last scheduled boundary, or tomorrow if there are none
        // (e.g. past the due date), so the widget never stops updating.
        let refreshDate = upcoming.last
            ?? calendar.date(byAdding: .day, value: 1, to: currentDate)
            ?? currentDate.addingTimeInterval(24 * 60 * 60)
        let timeline = Timeline(entries: entries, policy: .after(refreshDate))
        completion(timeline)
    }

    private static let maxEntries = 100

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
