//
//  CopyrightNotice.swift
//  Babedoo
//
//  Created by Caleb Friden on 11/1/22.
//

import SwiftUI

struct CopyrightNotice: View {
    var body: some View {
        Text("Copyright © 2022-" + String(year) + " Caleb Friden. All rights reserved.")
            .font(.footnote)
    }
    
    private var year: Int { Calendar.current.component(.year, from: Date()) }
}

struct CopyrightNotice_Previews: PreviewProvider {
    static var previews: some View {
        CopyrightNotice()
    }
}
