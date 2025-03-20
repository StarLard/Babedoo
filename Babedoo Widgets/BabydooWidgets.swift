//
//  BabydooWidgets.swift
//  Babydoo Widgets
//
//  Created by Caleb Friden on 10/19/22.
//

import WidgetKit
import SwiftUI

@main
struct BabydooWidgets: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
        CounterWidget()
        GuageWidget()
    }
}
