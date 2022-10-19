//
//  GuageWidget.swift
//  Babydoo WidgetsExtension
//
//  Created by Caleb Friden on 10/19/22.
//

import SwiftUI
import WidgetKit

struct GuageWidgetEntryView : View {
    var entry: Provider.Entry
    
    @Environment(\.widgetFamily)
    var family: WidgetFamily

    var body: some View {
        Gauge(value: progressPercentage) {
            switch entry.displayComponent {
            case .days:
                Text(value == 1 ? entry.displayComponent.singularUnit : entry.displayComponent.pluralUnit)
            case .weeks:
                Text(value == 1 ? "wk" : "wks")
            case .months:
                Text(value == 1 ? "mo" : "mos")
            }
        } currentValueLabel: {
            Text(value.formatted())
        }
        .tint(Gradient(colors: [.green, .blue]))
        .gaugeStyle(.accessoryCircular)
    }
    
    private var calculator: PregnancyCalculator { PregnancyCalculator(dueDate: entry.dueDate, conceptionDate: conceptionDate) }
    
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
    
    private var conceptionDate: Date {
        Calendar.current.date(byAdding: .month, value: -9, to: entry.dueDate) ?? entry.dueDate
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
                            .accessoryRectangular,
                            .systemSmall])
    }
}

struct GuageWidget_Previews: PreviewProvider {
    static var families = [
        WidgetFamily.accessoryCircular,
        .accessoryRectangular,
        .systemSmall,
    ]
    
    static var contexts = [
        WidgetPreviewContext(family: .accessoryCircular),
        WidgetPreviewContext(family: .accessoryRectangular),
        WidgetPreviewContext(family: .systemSmall),
    ]
    
    static var previews: some View {
        Group {
            ForEach(0..<3) { index in
                GuageWidgetEntryView(entry: SimpleEntry(date: .now,
                                                        dueDate: Date.now.addingTimeInterval(50 * 24 * 60 * 60),
                                                        displayComponent: .weeks,
                                                        configuration: ConfigurationIntent()))
                    .previewContext(contexts[index])
                    .previewDisplayName("\(families[index])")
            }
        }
    }
}
