//
//  BabedooApp.swift
//  Babedoo
//
//  Created by Caleb Friden on 10/19/22.
//

import SwiftUI

@main
struct BabedooApp: App {
    var body: some Scene {
        WindowGroup {
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
}
