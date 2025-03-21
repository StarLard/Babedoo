//
//  GuageWidget.swift
//  Babedoo WidgetsExtension
//
//  Created by Caleb Friden on 10/19/22.
//

import SwiftUI
import WidgetKit

@available(iOSApplicationExtension 16.0, *)
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
        if #available(iOSApplicationExtension 16.0, *) {
            return mainConfiguration
        } else {
            return EmptyWidgetConfiguration()
        }
    }
    
    @available(iOSApplicationExtension 16.0, *)
    private var mainConfiguration: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            GuageWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Progress Widget")
        .description("A visual representation of your pregnancy.")
        .supportedFamilies([.accessoryCircular,
                            .systemSmall])
    }
}

@available(iOSApplicationExtension 16.0, *)
struct GuageWidget_Previews: PreviewProvider {
    static var families = [
        WidgetFamily.accessoryCircular,
        .systemSmall,
    ]
    
    static var contexts: [WidgetPreviewContext] { families.map(WidgetPreviewContext.init(family:)) }
    
    static var previews: some View {
        Group {
            ForEach(0..<3) { index in
                GuageWidgetEntryView(entry: SimpleEntry(date: .now,
                                                        dueDate: Date.now.addingTimeInterval(50 * 24 * 60 * 60),
                                                        conceptionDate: Date.now.addingTimeInterval(-50 * 24 * 60 * 60),
                                                        displayComponent: .weeks,
                                                        configuration: ConfigurationIntent()))
                    .previewContext(contexts[index])
                    .previewDisplayName("\(families[index])")
            }
        }
    }
}
