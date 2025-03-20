//
//  AppInfo.swift
//  Babedoo
//
//  Created by Caleb Friden on 11/1/22.
//

import StarLardKit
import Foundation
#if canImport(UIKit)
import UIKit.UIDevice
#endif

/// Contains plist and process info
enum AppInfo {
    /// The app's display name
    static var displayName: String = NSLocalizedString("Babedoo", comment: "The display name for the app")
    
    /// An automatically generated ID assigned to the app by Apple.
    static var appleID: String = "6443924805"
        
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
        return URL(string: "itms-apps://itunes.apple.com/us/app/apple-store/id\(appleID)?mt=8")!
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
    
    static var marketingURL: URL = URL(string: "https://babedoo.starlard.dev")!
    static var privacyURL: URL = URL(string: "https://babedoo.starlard.dev/privacy")!
    static var supportURL: URL = URL(string: "https://babedoo.starlard.dev/support")!
}
