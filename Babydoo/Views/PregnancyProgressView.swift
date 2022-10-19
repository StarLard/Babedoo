//
//  PregnancyProgressView.swift
//  Babydoo
//
//  Created by Caleb Friden on 10/19/22.
//

import SwiftUI

struct PregnancyProgressView: View {
    var dueDate: Date
    var conceptionDate: Date
    
    var body: some View {
        HStack(alignment: .center) {
            Gauge(value: calculator.progressPercentage(from: now)) {
                EmptyView()
            } currentValueLabel: {
                Text(Int(calculator.progressPercentage(from: now) * 100).formatted(.percent))
            }
            .tint(Gradient(colors: [.green, .blue]))
            .gaugeStyle(.accessoryCircular)
            .frame(maxWidth: .infinity, minHeight: 64)
            
            Divider()
            
            dateComponentView(value: calculator.alongValue(from: now, for: dateDisplayComponent),
                              unit: calculator.alongValue(from: now, for: dateDisplayComponent) == 1
                              ? dateDisplayComponent.singularUnit
                              : dateDisplayComponent.pluralUnit,
                              suffix: "along")
            
            Divider()
            
            dateComponentView(value: calculator.remaingValue(from: now, for: dateDisplayComponent),
                              unit: calculator.remaingValue(from: now, for: dateDisplayComponent) == 1
                              ? dateDisplayComponent.singularUnit
                              : dateDisplayComponent.pluralUnit,
                              suffix: "to go")
        }
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation {
                dateDisplayComponent = dateDisplayComponent.next
            }
        }
    }
    
    @State
    private var dateDisplayComponent: DateDisplayComponent = .weeks
    private let now = Date.now
    private var calculator: PregnancyCalculator { PregnancyCalculator(dueDate: dueDate, conceptionDate: conceptionDate) }
    
    private func dateComponentView(value: Int,
                                   unit: String,
                                   suffix: LocalizedStringKey) -> some View {
        HStack(alignment: .lastTextBaseline, spacing: 4) {
            Text(value.formatted())
                .font(.title)
            
            VStack(alignment: .leading) {
                Text(unit)
                Text(suffix)
            }
            .font(.caption)
        }
        .frame(maxWidth: .infinity)
    }
}

struct PregnancyProgressView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            PregnancyProgressView(dueDate: .now.addingTimeInterval(50 * 24 * 60 * 60), conceptionDate: .now.addingTimeInterval(-40 * 24 * 60 * 60))
        }
    }
}
