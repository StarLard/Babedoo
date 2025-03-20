//
//  UserDefaults+App.swift
//  Babedoo
//
//  Created by Caleb Friden on 10/19/22.
//

import Foundation

extension UserDefaults {
    enum Key: String {
        case dueDate = "due-date"
        case conceptionDate = "conception-date"
    }

    // UserDefaults is thread-safe
    nonisolated(unsafe) static let appGroup: UserDefaults = UserDefaults(suiteName: "group.starlard.babydoo") ?? UserDefaults()

    var dueDate: Date? {
        get {
            date(forKey: .dueDate)
        }
        set {
            setDate(newValue, forKey: .dueDate)
        }
    }
    
    var conceptionDate: Date? {
        get {
            date(forKey: .conceptionDate)
        }
        set {
            setDate(newValue, forKey: .conceptionDate)
        }
    }
    
    func setDate(_ date: Date?, forKey key: Key) {
        setValue(date?.timeIntervalSince1970, forKey: key)
    }
    
    func date(forKey key: Key) -> Date? {
        guard let timeIntervalSince1970 = value(forKey: key) as? TimeInterval else { return nil }
        return Date(timeIntervalSince1970: timeIntervalSince1970)
    }
    
    func setValue(_ value: Any?, forKey key: Key) {
        setValue(value, forKey: key.rawValue)
    }
    
    func value(forKey key: Key) -> Any? {
        value(forKey: key.rawValue)
    }
}
