//
//  CounterWidget.swift
//  Babedoo WidgetsExtension
//
//  Created by Caleb Friden on 10/19/22.
//

import SwiftUI
import StarLardCoreKit
import WidgetKit

struct CounterWidgetEntryView : View {
    var entry: Provider.Entry
    
    @Environment(\.widgetFamily)
    var family: WidgetFamily

    @Environment(\.colorScheme)
    var colorScheme: ColorScheme

    var body: some View {
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
    }

    var content: some View {
        LinearGradient(colors: [.green, .blue], startPoint: .leading, endPoint: .trailing)
            .mask {
                HStack(alignment: .lastTextBaseline, spacing: 4) {
                    Text(value.formatted())
                        .font(family == .systemSmall ? .system(size: valueFontSize, weight: .semibold) : .title)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)

                    VStack(alignment: .leading) {
                        Text(entry.displayComponent.caption(for: value, direction: direction))
                    }
                    .font(family == .systemSmall ? .system(size: unitFontSize, weight: .light) : .caption)
                    .minimumScaleFactor(0.5)
                }
            }
            // Content inside a mask isn't exposed to VoiceOver, so describe it here.
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(entry.displayComponent.phrase(for: value, direction: direction))
    }

    /// Scales with Dynamic Type, relative to the closest text styles.
    @ScaledMetric(relativeTo: .largeTitle)
    private var valueFontSize: CGFloat = 52
    @ScaledMetric(relativeTo: .callout)
    private var unitFontSize: CGFloat = 16

    private var direction: TimeDirection {
        switch entry.configuration.timeValue {
        case .unknown, .progress:
            return .along
        case .remaining:
            return .remaining
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
    
    private let supportedFamilies: [WidgetFamily] = [
        .accessoryRectangular,
        .systemSmall,
    ]
}

struct CounterWidget_Previews: PreviewProvider {
    static let families: [WidgetFamily] = [
        .accessoryRectangular,
        .systemSmall,
    ]
    
    static var contexts: [WidgetPreviewContext] { families.map(WidgetPreviewContext.init(family:)) }
    
    static var previews: some View {
        Group {
            ForEach(0..<2) { index in
                CounterWidgetEntryView(entry: SimpleEntry(date: .current,
                                                          dueDate: Date.current.addingTimeInterval(50 * 24 * 60 * 60),
                                                          conceptionDate: Date.current,
                                                          displayComponent: .days,
                                                          configuration: ConfigurationIntent()))
                    .previewContext(contexts[index])
                    .previewDisplayName("\(families[index])")
            }
        }
    }
}
