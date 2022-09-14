//
//  UserDefaultsHelper.swift
//  DragonBallAdvanced
//
//  Created by Fran Alarza on 11/9/22.
//

import UIKit

enum UserDefaultsKeys: String {
    case tutorial
}

class UserDefaultsHelper {
    static var userDefaults = UserDefaults.standard
    
    static func saveItems<T>(item: T) {
        userDefaults.set(item, forKey: UserDefaultsKeys.tutorial.rawValue)
    }
    
    static func getItems<T>() -> T {
        userDefaults.bool(forKey: UserDefaultsKeys.tutorial.rawValue) as! T
    }
    
    static func delete() {
        userDefaults.removeObject(forKey: UserDefaultsKeys.tutorial.rawValue)
    }
}
