//
//  BabedooTests.swift
//  BabedooTests
//
//  Created by Caleb Friden on 10/19/22.
//

import Foundation
import Testing
@testable import Babedoo

// MARK: - Helpers

private let calendar = Calendar.current

/// A fixed, mid-day local date so tests don't depend on when or where they run.
private let conceptionDate = calendar.date(from: DateComponents(year: 2025, month: 3, day: 6, hour: 9))!

private func adding(_ value: Int, _ component: Calendar.Component, to date: Date = conceptionDate) -> Date {
    calendar.date(byAdding: component, value: value, to: date)!
}

private func makeCalculator(daysToDueDate: Int = PregnancyCalculator.daysFromConceptionDateToDueDate) -> PregnancyCalculator {
    PregnancyCalculator(dueDate: adding(daysToDueDate, .day), conceptionDate: conceptionDate)
}

// MARK: - PregnancyCalculator

struct PregnancyCalculatorTests {
    @Test
    func standardPregnancyIsThirtyEightWeeks() {
        #expect(PregnancyCalculator.daysFromConceptionDateToDueDate == 38 * 7)
    }

    @Test
    func progressPercentage() {
        let calculator = makeCalculator()
        #expect(calculator.progressPercentage(from: conceptionDate) == 0)
        // Within an hour of halfway, since daylight saving time can shift the midpoint.
        #expect(abs(calculator.progressPercentage(from: adding(133, .day)) - 0.5) < 1.0 / (266 * 24))
        #expect(calculator.progressPercentage(from: calculator.dueDate) == 1)
    }

    @Test
    func progressPercentageIsCappedAtOneAfterDueDate() {
        let calculator = makeCalculator()
        #expect(calculator.progressPercentage(from: adding(10, .day, to: calculator.dueDate)) == 1)
    }

    @Test
    func progressPercentageIsOneWhenDueDateEqualsConceptionDate() {
        let calculator = makeCalculator(daysToDueDate: 0)
        #expect(calculator.progressPercentage(from: conceptionDate) == 1)
    }

    @Test(arguments: [
        (DateDisplayComponent.days, 0, 0),
        (.days, 90, 90),
        (.weeks, 6, 0),
        (.weeks, 7, 1),
        (.weeks, 90, 12),
        (.months, 30, 0),
        (.months, 31, 1),
        (.months, 266, 8),
    ])
    func alongValue(component: DateDisplayComponent, daysSinceConception: Int, expected: Int) {
        let calculator = makeCalculator()
        #expect(calculator.alongValue(from: adding(daysSinceConception, .day), for: component) == expected)
    }

    @Test(arguments: [
        (DateDisplayComponent.days, 0, 266),
        (.days, 266, 0),
        (.weeks, 0, 38),
        (.weeks, 90, 25),
        (.weeks, 266, 0),
        (.months, 0, 8),
    ])
    func remainingValue(component: DateDisplayComponent, daysSinceConception: Int, expected: Int) {
        let calculator = makeCalculator()
        #expect(calculator.remaingValue(from: adding(daysSinceConception, .day), for: component) == expected)
    }

    @Test
    func alongWeeksTickOverExactlyAtWeekBoundary() {
        let calculator = makeCalculator()
        let boundary = adding(13, .weekOfYear)
        #expect(calculator.alongValue(from: boundary.addingTimeInterval(-1), for: .weeks) == 12)
        #expect(calculator.alongValue(from: boundary, for: .weeks) == 13)
    }
}

// MARK: - Widget update dates

struct ValueChangeDatesTests {
    @Test(arguments: [DateDisplayComponent.days, .weeks, .months])
    func datesAreUpcomingSortedUniqueAndLimited(component: DateDisplayComponent) {
        let now = adding(40, .day)
        let dates = makeCalculator().valueChangeDates(after: now, for: component, limit: 20)
        #expect(!dates.isEmpty)
        #expect(dates.count <= 20)
        #expect(dates.allSatisfy { $0 > now })
        #expect(dates == dates.sorted())
        #expect(Set(dates).count == dates.count)
    }

    @Test
    func zeroLimitReturnsNoDates() {
        #expect(makeCalculator().valueChangeDates(after: conceptionDate, for: .weeks, limit: 0).isEmpty)
    }

    /// The original bug: entries were spaced from when the timeline was generated (here a Monday afternoon) instead of
    /// from the conception date (a Thursday morning), so the widget showed the previous week for days.
    @Test
    func firstWeeklyUpdateIsAtNextWeekBoundaryNotAWeekFromNow() {
        let now = adding(12 * 7 + 4, .day).addingTimeInterval(6 * 60 * 60)
        let first = makeCalculator().valueChangeDates(after: now, for: .weeks, limit: 1).first
        #expect(first == adding(13, .weekOfYear))
    }

    @Test(arguments: [DateDisplayComponent.days, .weeks, .months])
    func everyDateChangesTheDisplayedValue(component: DateDisplayComponent) {
        // A due date that isn't a whole number of weeks after conception, so "along" and "to go" flip at different times.
        let calculator = makeCalculator(daysToDueDate: 270)
        for date in calculator.valueChangeDates(after: conceptionDate, for: component, limit: 100) {
            let before = date.addingTimeInterval(-1)
            let alongChanged = calculator.alongValue(from: before, for: component) != calculator.alongValue(from: date, for: component)
            let remainingChanged = calculator.remaingValue(from: before, for: component) != calculator.remaingValue(from: date, for: component)
            #expect(alongChanged || remainingChanged, "Nothing changes at \(date)")
        }
    }

    @Test(arguments: [DateDisplayComponent.days, .weeks])
    func noValueChangeIsMissed(component: DateDisplayComponent) {
        let calculator = makeCalculator(daysToDueDate: 270)
        let start = adding(30, .day).addingTimeInterval(37 * 60)
        let dates = calculator.valueChangeDates(after: start, for: component, limit: 100)
        guard let end = dates.last else {
            Issue.record("No update dates")
            return
        }

        // Step through the scheduled window hourly; any change in either value must have an update scheduled for it.
        var previous = start
        while previous < end {
            let next = min(previous.addingTimeInterval(60 * 60), end)
            let changed = calculator.alongValue(from: previous, for: component) != calculator.alongValue(from: next, for: component)
                || calculator.remaingValue(from: previous, for: component) != calculator.remaingValue(from: next, for: component)
            if changed {
                #expect(dates.contains { $0 > previous && $0 <= next }, "Missed a change between \(previous) and \(next)")
            }
            previous = next
        }
    }

    @Test
    func keepsSchedulingUpdatesAfterDueDate() {
        let calculator = makeCalculator()
        let overdue = adding(3, .day, to: calculator.dueDate)
        #expect(!calculator.valueChangeDates(after: overdue, for: .weeks, limit: 10).isEmpty)
    }
}

// MARK: - DateDisplayComponent

struct DateDisplayComponentTests {
    @Test
    func nextCyclesThroughAllComponents() {
        #expect(DateDisplayComponent.days.next == .weeks)
        #expect(DateDisplayComponent.weeks.next == .months)
        #expect(DateDisplayComponent.months.next == .days)
    }

    @Test(arguments: [
        (DateDisplayComponent.days, 1, TimeDirection.along, "day\nalong"),
        (.days, 0, .remaining, "days\nto go"),
        (.days, 2, .along, "days\nalong"),
        (.weeks, 1, .remaining, "week\nto go"),
        (.weeks, 13, .along, "weeks\nalong"),
        (.months, 1, .along, "month\nalong"),
        (.months, 4, .remaining, "months\nto go"),
    ])
    func captionIsPluralizedWithoutNumber(component: DateDisplayComponent, quantity: Int, direction: TimeDirection, expected: String) {
        #expect(component.caption(for: quantity, direction: direction) == expected)
    }

    @Test(arguments: [
        (DateDisplayComponent.days, 1, TimeDirection.along, "1 day along"),
        (.days, 0, .remaining, "0 days to go"),
        (.weeks, 1, .remaining, "1 week to go"),
        (.weeks, 13, .along, "13 weeks along"),
        (.months, 1, .along, "1 month along"),
        (.months, 4, .remaining, "4 months to go"),
    ])
    func phraseIncludesPluralizedNumber(component: DateDisplayComponent, quantity: Int, direction: TimeDirection, expected: String) {
        #expect(component.phrase(for: quantity, direction: direction) == expected)
    }

    @Test(arguments: [
        (DateDisplayComponent.days, 1, "day"),
        (.days, 2, "days"),
        (.weeks, 1, "wk"),
        (.weeks, 13, "wks"),
        (.months, 1, "mo"),
        (.months, 4, "mos"),
    ])
    func abbreviatedUnitIsPluralized(component: DateDisplayComponent, quantity: Int, expected: String) {
        #expect(component.abbreviatedUnit(for: quantity) == expected)
    }
}

// MARK: - UserDefaults

struct UserDefaultsDateTests {
    private let suiteName = "BabedooTests.\(UUID().uuidString)"
    private var defaults: UserDefaults { UserDefaults(suiteName: suiteName)! }

    @Test
    func datesAreNilWhenUnset() {
        #expect(defaults.dueDate == nil)
        #expect(defaults.conceptionDate == nil)
    }

    @Test
    func datesRoundTrip() {
        let defaults = defaults
        defer { defaults.removePersistentDomain(forName: suiteName) }
        let dueDate = adding(266, .day)

        defaults.dueDate = dueDate
        defaults.conceptionDate = conceptionDate

        #expect(defaults.dueDate == dueDate)
        #expect(defaults.conceptionDate == conceptionDate)
    }

    @Test
    func settingNilClearsDate() {
        let defaults = defaults
        defer { defaults.removePersistentDomain(forName: suiteName) }

        defaults.dueDate = conceptionDate
        defaults.dueDate = nil

        #expect(defaults.dueDate == nil)
    }

    @Test
    func datesAreStoredUnderSharedKeys() {
        let defaults = defaults
        defer { defaults.removePersistentDomain(forName: suiteName) }

        defaults.dueDate = conceptionDate

        // The widget extension reads these raw keys, so they must not change.
        #expect(defaults.double(forKey: "due-date") == conceptionDate.timeIntervalSince1970)
        #expect(defaults.object(forKey: "conception-date") == nil)
    }
}

// MARK: - AppInfo

struct AppInfoTests {
    @Test
    func bundleIdentifier() {
        #expect(AppInfo.bundleIdentifier == "com.starlard.Babydoo")
    }

    @Test
    func versionParsesFromInfoPlist() {
        #expect(!AppInfo.version.description.isEmpty)
        #expect(!AppInfo.buildString.isEmpty)
    }

    @Test
    func appStoreURLContainsAppleID() {
        // App Store links work with or without the "id" prefix on the app number.
        #expect(AppInfo.appStoreURL.lastPathComponent.hasSuffix(AppInfo.appleID))
    }
}

// MARK: - PrivacyInfoView

struct PrivacyStatementTests {
    @Test
    func linksPrivacyPolicy() {
        let statement = PrivacyInfoView.privacyStatement
        let links = statement.runs.compactMap { run in run.link.map { (String(statement[run.range].characters), $0) } }
        #expect(links.count == 1)
        #expect(links.first?.0 == "privacy policy")
        #expect(links.first?.1 == AppInfo.privacyURL)
    }

    @Test
    func includesAppName() {
        let text = String(PrivacyInfoView.privacyStatement.characters)
        #expect(text.hasPrefix("\(AppInfo.displayName) and its developer"))
        #expect(!text.contains("%@"))
    }
}
