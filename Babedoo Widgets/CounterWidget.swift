//
//  CounterWidget.swift
//  Babedoo WidgetsExtension
//
//  Created by Caleb Friden on 10/19/22.
//

import SwiftUI
import WidgetKit

struct CounterWidgetEntryView : View {
    var entry: Provider.Entry
    
    @Environment(\.widgetFamily)
    var family: WidgetFamily

    @Environment(\.colorScheme)
    var colorScheme: ColorScheme

    var body: some View {
        if #available(iOSApplicationExtension 17.0, *) {
            content
                .containerBackground(for: .widget) {
                    switch colorScheme {
                    case .dark:
                        Color.black
                    case .light:
                        Color.white
                    @unknown default:
                        Color.white
                    }
                }
        } else {
            content
        }
    }

    var content: some View {
        LinearGradient(colors: [.green, .blue], startPoint: .leading, endPoint: .trailing)
            .mask {
                HStack(alignment: .lastTextBaseline, spacing: 4) {
                    Text(value.formatted())
                        .font(family == .systemSmall ? .system(size: 52, weight: .semibold) : .title)

                    VStack(alignment: .leading) {
                        switch entry.configuration.timeValue {
                        case .unknown, .progress:
                            Text("\(entry.displayComponent.unit(for: value))\nalong")
                        case .remaining:
                            Text("\(entry.displayComponent.unit(for: value))\nto go")
                        }
                    }
                    .font(family == .systemSmall ? .system(size: 16, weight: .light) : .caption)
                }
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
}

struct CounterWidget: Widget {
    let kind: String = "CounterWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            CounterWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Counter Widget")
        .description("A textual representation of your pregnancy.")
        .supportedFamilies(supportedFamilies)
    }
    
    private var supportedFamilies: [WidgetFamily] {
        if #available(iOSApplicationExtension 16.0, *) {
            return [
                WidgetFamily.accessoryRectangular,
                .systemSmall,
            ]
        } else {
            return [
                WidgetFamily.systemSmall,
            ]
        }
    }
}

struct CounterWidget_Previews: PreviewProvider {
    static var families: [WidgetFamily] {
        if #available(iOSApplicationExtension 16.0, *) {
            return [
                WidgetFamily.accessoryRectangular,
                .systemSmall,
            ]
        } else {
            return [
                WidgetFamily.systemSmall,
            ]
        }
    }
    
    static var contexts: [WidgetPreviewContext] { families.map(WidgetPreviewContext.init(family:)) }
    
    static var previews: some View {
        Group {
            ForEach(0..<2) { index in
                CounterWidgetEntryView(entry: SimpleEntry(date: .now,
                                                          dueDate: Date.now.addingTimeInterval(50 * 24 * 60 * 60),
                                                          conceptionDate: Date.now,
                                                          displayComponent: .days,
                                                          configuration: ConfigurationIntent()))
                    .previewContext(contexts[index])
                    .previewDisplayName("\(families[index])")
            }
        }
    }
}
