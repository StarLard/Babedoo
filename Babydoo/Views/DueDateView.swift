//
//  DueDateView.swift
//  Babydoo
//
//  Created by Caleb Friden on 10/19/22.
//

import SwiftUI
import StarLardKit
import WidgetKit

struct DueDateView: View {
    @State
    var dueDate: Date
    
    @State
    var isDueDateSet: Bool
    
    var body: some View {
        List {
            Section {
                DatePicker(selection: $dueDate,
                           displayedComponents: [.date]) {
                    Label("Due Date", systemImage: "calendar")
                }
            } footer: {
                if isDueDateSet {
                    Text("Estimated conception: \(conceptionDate.formatted(date: .abbreviated, time: .omitted))")
                } else {
                    Text("When are you expecting?")
                }
            }
            if isDueDateSet {
                Section {
                    PregnancyProgressView(dueDate: dueDate, conceptionDate: conceptionDate)
                } header: {
                    Text("Progress")
                }
            }
        }.onChange(of: dueDate) { newValue in
            if !DeploymentEnvironment.isRunningForPreviews {
                userDefaults.dueDate = newValue
                WidgetCenter.shared.reloadAllTimelines()
            }
            withAnimation {
                isDueDateSet = true
            }
        }
    }
    
    init() {
        if DeploymentEnvironment.isRunningForPreviews {
            _dueDate = State(initialValue: .now)
            _isDueDateSet = State(initialValue: false)
        } else {
            let date = userDefaults.dueDate
            _dueDate = State(initialValue: date ?? .now)
            _isDueDateSet = State(initialValue: date != nil)
        }
    }
    
    private let userDefaults = UserDefaults.appGroup
    private let calendar = Calendar.current

    private var conceptionDate: Date {
        calendar.date(byAdding: .month, value: -9, to: dueDate) ?? dueDate
    }
}

struct DueDateView_Previews: PreviewProvider {
    static var previews: some View {
        DueDateView()
    }
}
