//
//  DeploymentEnvironment+App.swift
//  Babedoo
//
//  Created by Caleb Friden on 10/19/22.
//

import Foundation
import StarLardKit

extension DeploymentEnvironment {
    static var current: DeploymentEnvironment {
        #if DEBUG || targetEnvironment(simulator)
        return .development
        #else
        if isRunningForPreviews || isRunningForUITests { return .development }
        else if isSimulatorOrTestFlightInstall { return .testing }
        return .production
        #endif
    }
    
    /// For an application installed through TestFlight Beta the receipt file is named
    /// `StoreKit\sandboxReceipt` vs the usual `StoreKit\receipt` for
    /// an app store install. Checking `Bundle.main.appStoreReceiptURL`
    /// for `sandboxReceipt` tells us whether or not this is an app store install.
    private static var isSimulatorOrTestFlightInstall: Bool { Bundle.main.appStoreReceiptURL?.path.contains("sandboxReceipt") == true }
}
