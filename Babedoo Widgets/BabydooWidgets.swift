//
//  BabedooWidgets.swift
//  Babedoo Widgets
//
//  Created by Caleb Friden on 10/19/22.
//

import WidgetKit
import SwiftUI

@main
struct BabedooWidgets: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
        CounterWidget()
        GuageWidget()
    }
}
