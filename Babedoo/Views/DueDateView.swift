//
//  DueDateView.swift
//  Babedoo
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
    var conceptionDate: Date
    
    @State
    var isDueDateSet: Bool
    
    @State
    var isConceptionDateSet: Bool
    
    @State
    var isAppInfoPresented = false
    
    var body: some View {
        List {
            Section {
                DatePicker(selection: $dueDate,
                           displayedComponents: [.date]) {
                    Label("Due Date", systemImage: "calendar")
                }
                
                if isDueDateSet {
                    DatePicker(selection: $conceptionDate,
                               displayedComponents: [.date]) {
                        Label("Conception Date", systemImage: "calendar")
                    }
                }
            } footer: {
                if !isDueDateSet {
                    Text("When are you expecting?")
                } else if !isConceptionDateSet {
                    Text("When did you conceive?")
                }
            }
            
            if isConceptionDateSet {
                Section {
                    PregnancyProgressView(dueDate: dueDate, conceptionDate: conceptionDate)
                } header: {
                    Text("Progress")
                }
            }
        }
        .navigationTitle("Hello!")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    withAnimation {
                        isAppInfoPresented = true
                    }
                } label: {
                    Image(systemName: "info.circle")
                }
            }
        }.sheet(isPresented: $isAppInfoPresented) {
            NavigationView {
                AppInfoView()
            }
        }.onChange(of: dueDate) { newValue in
            if !DeploymentEnvironment.isRunningForPreviews {
                userDefaults.dueDate = newValue
                WidgetCenter.shared.reloadAllTimelines()
            }
            withAnimation {
                isDueDateSet = true
                if let estimatedConceptionDate = calendar.date(byAdding: .day, value: -PregnancyCalculator.daysFromConceptionDateToDueDate, to: dueDate) {
                    conceptionDate = estimatedConceptionDate
                }
            }
        }.onChange(of: conceptionDate) { newValue in
            if !DeploymentEnvironment.isRunningForPreviews {
                userDefaults.conceptionDate = newValue
                WidgetCenter.shared.reloadAllTimelines()
            }
            withAnimation {
                isConceptionDateSet = true
            }
        }
    }
    
    init() {
        let now = Date.now
        if DeploymentEnvironment.isRunningForPreviews {
            _dueDate = State(initialValue: now)
            _isDueDateSet = State(initialValue: false)
            _conceptionDate = State(initialValue: now)
            _isConceptionDateSet = State(initialValue: false)
        } else {
            let savedDueDate = userDefaults.dueDate
            let savedConceptionDate = userDefaults.conceptionDate
            _dueDate = State(initialValue: savedDueDate ?? now)
            _isDueDateSet = State(initialValue: savedDueDate != nil)
            _conceptionDate = State(initialValue: savedConceptionDate ?? now)
            _isConceptionDateSet = State(initialValue: savedConceptionDate != nil)
        }
    }
    
    private let userDefaults = UserDefaults.appGroup
    private let calendar = Calendar.current
}

struct DueDateView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 16.0, *) {
            NavigationStack {
                DueDateView()
            }
        } else {
            NavigationView {
                DueDateView()
            }
            .navigationViewStyle(.stack)
        }
    }
}
