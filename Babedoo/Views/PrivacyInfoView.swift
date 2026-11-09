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
            Text(Self.privacyStatement)
        }
        .navigationTitle("Privacy")
    }

    nonisolated static var privacyStatement: AttributedString {
        var privacyPolicy = AttributedString(localized: "privacy policy", comment: "Link text to the privacy policy, used in the privacy statement")
        privacyPolicy.link = AppInfo.privacyURL
        return AttributedString(
            localized: "\(AppInfo.displayName) and its developer take your privacy very seriously. \(AppInfo.displayName) does not collect any data about you. Ever. To learn more, read our \(privacyPolicy).",
            comment: "Privacy statement; the first two placeholders are the app name and the last is a link to the privacy policy"
        )
    }
}

struct PrivacyInfoView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            PrivacyInfoView()
        }
    }
}
