//
//  CopyrightNotice.swift
//  Babedoo
//
//  Created by Caleb Friden on 11/1/22.
//

import SwiftUI
import StarLardCoreKit

struct CopyrightNotice: View {
    var body: some View {
        Text("Copyright © 2022-\(year) Caleb Friden. All rights reserved.", comment: "Copyright notice; the placeholder is the current year")
            .font(.footnote)
    }

    /// The current Gregorian year as a bare number (2026, not 2,026 or 2026年),
    /// regardless of the user's calendar and locale.
    private var year: String {
        Calendar(identifier: .gregorian).component(.year, from: .current).formatted(.number.grouping(.never))
    }
}

struct CopyrightNotice_Previews: PreviewProvider {
    static var previews: some View {
        CopyrightNotice()
    }
}
