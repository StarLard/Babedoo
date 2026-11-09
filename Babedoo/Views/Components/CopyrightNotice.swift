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

    /// The current year, formatted without grouping separators (2026, not 2,026).
    private var year: String { Date.current.formatted(.dateTime.year()) }
}

struct CopyrightNotice_Previews: PreviewProvider {
    static var previews: some View {
        CopyrightNotice()
    }
}
