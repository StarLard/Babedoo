//
//  PrivacyInfoView.swift
//  Babedoo
//
//  Created by Caleb Friden on 11/1/22.
//

import SwiftUI

struct PrivacyInfoView: View {
    var body: some View {
        List {
            Text(.init("\(AppInfo.displayName) and its developer take your privacy very seriously. \(AppInfo.displayName) does not collect any data about you. Ever. To learn more, read our [privacy policy](\(AppInfo.privacyURL))."))
        }
        .navigationTitle("Privacy")
    }
}

struct PrivacyInfoView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 16.0, *) {
            NavigationStack {
                PrivacyInfoView()
            }
        } else {
            NavigationView {
                PrivacyInfoView()
            }
        }
    }
}
