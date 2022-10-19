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
            Gauge(value: progressPercentage) {
                EmptyView()
            } currentValueLabel: {
                Text(Int(progressPercentage * 100).formatted(.percent))
            }
            .tint(Gradient(colors: [.green, .blue]))
            .gaugeStyle(.accessoryCircular)
            .frame(maxWidth: .infinity, minHeight: 64)
            
            Divider()
            
            dateComponentView(value: alongValue(for: dateComponent),
                              unit: dateComponent.unit,
                              suffix: "along")

            Divider()
            
            dateComponentView(value: remaingValue(for: dateComponent),
                              unit: dateComponent.unit,
                              suffix: "to go")
        }
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation {
                dateComponent = dateComponent.next
            }
        }
    }
    
    @State
    private var dateComponent: DateComponent = .weeks
    
    private enum DateComponent {
        case days
        case weeks
        case months
        
        var unit: LocalizedStringKey {
            switch self {
            case .days: return "days"
            case .weeks: return "weeks"
            case .months: return "months"
            }
        }
        
        var next: Self {
            switch self {
            case .days: return .weeks
            case .weeks: return .months
            case .months: return .days
            }
        }
    }
    
    private let calendar = Calendar.current
    
    private var progressPercentage: Double {
        let timeUntilDueDate = dueDate.timeIntervalSince(conceptionDate)
        guard timeUntilDueDate != 0 else { return 1 }
        let timeFromConception = Date.now.timeIntervalSince(conceptionDate)
        return min(1, timeFromConception / timeUntilDueDate)
    }
    
    private func dateComponentView(value: Int,
                                   unit: LocalizedStringKey,
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
    
    private func remaingValue(for dateComponent: DateComponent) -> Int {
        switch dateComponent {
        case .days:
            let components = calendar.dateComponents([.day], from: .now, to: dueDate)
            return components.day ?? 0
        case .weeks:
            let components = calendar.dateComponents([.weekOfYear], from: .now, to: dueDate)
            return components.weekOfYear ?? 0
        case .months:
            let components = calendar.dateComponents([.month], from: .now, to: dueDate)
            return components.month ?? 0
        }
    }
    
    private func alongValue(for dateComponent: DateComponent) -> Int {
        switch dateComponent {
        case .days:
            let components = calendar.dateComponents([.day], from: conceptionDate, to: .now)
            return components.day ?? 0
        case .weeks:
            let components = calendar.dateComponents([.weekOfYear], from: conceptionDate, to: .now)
            return components.weekOfYear ?? 0
        case .months:
            let components = calendar.dateComponents([.month], from: conceptionDate, to: .now)
            return components.month ?? 0
        }
    }
}

struct PregnancyProgressView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            PregnancyProgressView(dueDate: .now.addingTimeInterval(50 * 24 * 60 * 60), conceptionDate: .now.addingTimeInterval(-40 * 24 * 60 * 60))
        }
    }
}
