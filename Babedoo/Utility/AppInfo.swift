//
//  AppInfo.swift
//  Babedoo
//
//  Created by Caleb Friden on 11/1/22.
//

import StarLardCoreKit
import Foundation
import UIKit.UIDevice

/// Contains plist and process info
enum AppInfo {
    /// The app's display name
    static let displayName: String = String(localized: "Babedoo", comment: "The display name for the app")

    /// An automatically generated ID assigned to the app by Apple.
    static let appleID: String = "6443924805"

    static var bundleIdentifier: String {
        guard let identifier = Bundle.main.bundleIdentifier else {
            fatalError("Could not determine bundle identifier string from main bundle plist")
        }
        return identifier
    }
    
    static var versionString: String {
        guard let plist = Bundle.main.infoDictionary,
              let versionString = plist["CFBundleShortVersionString"] as? String else {
            fatalError("Could not determine version string from main bundle plist")
        }
        return versionString
    }
    
    static var buildString: String {
        guard let plist = Bundle.main.infoDictionary,
              let versionString = plist["CFBundleVersion"] as? String else {
            fatalError("Could not determine build string from main bundle plist")
        }
        return versionString
    }
            
    static var appStoreURL: URL {
        return URL(string: "https://apps.apple.com/us/app/babedoo/\(appleID)")!
    }
    
    static var version: AppVersion {
        guard let version = AppVersion(AppInfo.versionString) else {
            fatalError("Version string from main bundle plist was in unexpected format")
        }
        return version
    }
    
    static var icon: UIImage {
        guard let plist = Bundle.main.infoDictionary,
              let icons = plist["CFBundleIcons"] as? [String: Any],
              let primaryIcon = icons["CFBundlePrimaryIcon"] as? [String: Any],
              let iconFiles = primaryIcon["CFBundleIconFiles"] as? [String],
              let lastIcon = iconFiles.last,
              let image = UIImage(named: lastIcon) else {
            fatalError("Could not load icon from main bundle plist")
        }
        return image
    }
    
    static let marketingURL: URL = URL(string: "https://babedoo.starlard.dev")!
    static let privacyURL: URL = URL(string: "https://babedoo.starlard.dev/privacy")!
    static let supportURL: URL = URL(string: "https://babedoo.starlard.dev/support")!
}
