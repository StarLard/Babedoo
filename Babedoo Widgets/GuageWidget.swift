//
//  GuageWidget.swift
//  Babedoo WidgetsExtension
//
//  Created by Caleb Friden on 10/19/22.
//

import SwiftUI
import StarLardCoreKit
import WidgetKit

struct GuageWidgetEntryView : View {
    var entry: Provider.Entry
    
    @Environment(\.widgetFamily)
    var family: WidgetFamily

    var body: some View {
        Gauge(value: progressPercentage) {
            Text(entry.displayComponent.abbreviatedUnit(for: value))
        } currentValueLabel: {
            Text(value.formatted())
        }
        .tint(Gradient(colors: [.green, .blue]))
        .gaugeStyle(.accessoryCircular)
        // The visible label is an abbreviation, so give VoiceOver the full description.
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Text("Pregnancy progress", comment: "Accessibility label for the progress widget"))
        .accessibilityValue(accessibilityValue)
    }

    private var accessibilityValue: Text {
        let percent = Int(progressPercentage * 100).formatted(.percent)
        let unit = entry.displayComponent.unit(for: value)
        switch entry.configuration.timeValue {
        case .unknown, .progress:
            return Text("\(percent) complete, \(value.formatted()) \(unit) along", comment: "Accessibility value for the progress widget; placeholders are the percent complete, the value, and the unit")
        case .remaining:
            return Text("\(percent) complete, \(value.formatted()) \(unit) to go", comment: "Accessibility value for the progress widget; placeholders are the percent complete, the value, and the unit")
        }
    }
    
    private var calculator: PregnancyCalculator { PregnancyCalculator(dueDate: entry.dueDate, conceptionDate: entry.conceptionDate) }
    
    private var value: Int {
        switch entry.configuration.timeValue {
        case .unknown, .progress:
            return calculator.alongValue(from: entry.date, for: entry.displayComponent)
        case .remaining:
            return calculator.remaingValue(from: entry.date, for: entry.displayComponent)
        }
    }
    
    var progressPercentage: Double {
        calculator.progressPercentage(from: entry.date)
    }
}

struct GuageWidget: Widget {
    let kind: String = "GuageWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            GuageWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Progress Widget")
        .description("A visual representation of your pregnancy.")
        .supportedFamilies([.accessoryCircular,
                            .systemSmall])
    }
}

struct GuageWidget_Previews: PreviewProvider {
    static var families = [
        WidgetFamily.accessoryCircular,
        .systemSmall,
    ]
    
    static var contexts: [WidgetPreviewContext] { families.map(WidgetPreviewContext.init(family:)) }
    
    static var previews: some View {
        Group {
            ForEach(families.indices, id: \.self) { index in
                GuageWidgetEntryView(entry: SimpleEntry(date: .current,
                                                        dueDate: Date.current.addingTimeInterval(50 * 24 * 60 * 60),
                                                        conceptionDate: Date.current.addingTimeInterval(-50 * 24 * 60 * 60),
                                                        displayComponent: .weeks,
                                                        configuration: ConfigurationIntent()))
                    .previewContext(contexts[index])
                    .previewDisplayName("\(families[index])")
            }
        }
    }
}
