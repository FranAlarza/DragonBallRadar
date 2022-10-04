//
//  UserDefaultsHelper.swift
//  DragonBallAdvanced
//
//  Created by Fran Alarza on 11/9/22.
//

import UIKit

enum UserDefaultsKeys: String {
    case tutorial
    case user
    case syncDate
}

class UserDefaultsHelper {
    static var userDefaults = UserDefaults.standard
    
    static func saveItems<T>(item: T, key: UserDefaultsKeys) {
        userDefaults.set(item, forKey: key.rawValue)
    }
    
    static func getItems(key: UserDefaultsKeys) -> Any? {
        userDefaults.value(forKey: key.rawValue)
    }
    
    static func deleteItem(key: UserDefaultsKeys) {
        userDefaults.removeObject(forKey: key.rawValue)
    }
    
    static func saveSyncDate(key: UserDefaultsKeys) {
        userDefaults.set(Date(), forKey: key.rawValue)
    }
    
    static func getSyncDate(key: UserDefaultsKeys) -> Date? {
        userDefaults.value(forKey: key.rawValue) as? Date
    }
}
