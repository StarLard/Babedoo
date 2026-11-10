//
//  PregnancyProgressView.swift
//  Babedoo
//
//  Created by Caleb Friden on 10/19/22.
//

import SwiftUI
import StarLardCoreKit

struct PregnancyProgressView: View {
    var dueDate: Date
    var conceptionDate: Date
    
    var body: some View {
        // Stack vertically at accessibility text sizes so the values have room to grow.
        let layout = dynamicTypeSize.isAccessibilitySize
            ? AnyLayout(VStackLayout(spacing: 12))
            : AnyLayout(HStackLayout(alignment: .center))

        layout {
            Gauge(value: progressPercentage) {
                EmptyView()
            } currentValueLabel: {
                Text(percentText)
            }
            .tint(Gradient(colors: [.green, .blue]))
            .gaugeStyle(.accessoryCircular)
            .frame(maxWidth: .infinity, minHeight: 64)

            Divider()
            
            dateComponentView(
                value: alongValue,
                dateDisplayComponent: dateDisplayComponent,
                direction: .along
            )

            Divider()

            dateComponentView(
                value: remainingValue,
                dateDisplayComponent: dateDisplayComponent,
                direction: .remaining
            )
        }
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation {
                dateDisplayComponent = dateDisplayComponent.next
            }
        }
        // Present the whole row to VoiceOver as one button that reads every value.
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Text("Pregnancy progress", comment: "Accessibility label for the progress summary"))
        .accessibilityValue(Text(
            "\(percentText) complete, \(dateDisplayComponent.phrase(for: alongValue, direction: .along)), \(dateDisplayComponent.phrase(for: remainingValue, direction: .remaining))",
            comment: "Accessibility value for the progress summary; placeholders are the percent complete, the time along (e.g. \"12 weeks along\"), and the time remaining (e.g. \"28 weeks to go\")"
        ))
        .accessibilityHint(Text("Changes the unit of time", comment: "Accessibility hint for the progress summary"))
        .accessibilityAddTraits(.isButton)
    }
    
    @Environment(\.dynamicTypeSize)
    private var dynamicTypeSize
    @State
    private var dateDisplayComponent: DateDisplayComponent = .weeks
    private let now = Date.current
    private var calculator: PregnancyCalculator { PregnancyCalculator(dueDate: dueDate, conceptionDate: conceptionDate) }
    private var progressPercentage: Double { calculator.progressPercentage(from: now) }
    private var percentText: String { Int(progressPercentage * 100).formatted(.percent) }
    private var alongValue: Int { calculator.alongValue(from: now, for: dateDisplayComponent) }
    private var remainingValue: Int { calculator.remaingValue(from: now, for: dateDisplayComponent) }
    
    private func dateComponentView(value: Int,
                                   dateDisplayComponent: DateDisplayComponent,
                                   direction: TimeDirection) -> some View {
        HStack(alignment: .lastTextBaseline, spacing: 4) {
            Text(value.formatted())
                .font(.title)

            VStack(alignment: .leading) {
                Text(dateDisplayComponent.caption(for: value, direction: direction))
            }
            .font(.caption)
        }
        .frame(maxWidth: .infinity)
    }
}

struct PregnancyProgressView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            PregnancyProgressView(dueDate: .current.addingTimeInterval(50 * 24 * 60 * 60), conceptionDate: .current.addingTimeInterval(-40 * 24 * 60 * 60))
        }
    }
}
