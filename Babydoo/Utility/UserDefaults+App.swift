//
//  UserDefaults+App.swift
//  Babydoo
//
//  Created by Caleb Friden on 10/19/22.
//

import Foundation

extension UserDefaults {
    enum Key: String {
        case dueDate = "due-date"
    }
    
    static let appGroup: UserDefaults = UserDefaults(suiteName: "group.starlard.babydoo") ?? UserDefaults()
    
    var dueDate: Date? {
        get {
            guard let timeIntervalSince1970 = value(forKey: Key.dueDate.rawValue) as? TimeInterval else { return nil }
            return Date(timeIntervalSince1970: timeIntervalSince1970)
        }
        set {
            guard let timeIntervalSince1970 = newValue?.timeIntervalSince1970 else { return }
            setValue(timeIntervalSince1970, forKey: Key.dueDate.rawValue)
        }
    }
}
