//
//  PrivacyInfoView.swift
//  Babydoo
//
//  Created by Caleb Friden on 11/1/22.
//

import SwiftUI

struct PrivacyInfoView: View {
    var body: some View {
        List {
            Text(.init("\(AppInfo.displayName) and its developer take your privacy very seriously. No data about you or how you use the app is collected ever."))
                .padding()
        }
        .navigationTitle("Privacy")
    }
}

struct PrivacyInfoView_Previews: PreviewProvider {
    static var previews: some View {
        PrivacyInfoView()
    }
}
