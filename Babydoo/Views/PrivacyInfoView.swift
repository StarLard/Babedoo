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
            Text(.init("\(AppInfo.displayName) and its developer take your privacy very seriously. \(AppInfo.displayName) does not collect any data about you. Ever."))
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
