//
//  KeyChainHelper.swift
//  DragonBallAdvanced
//
//  Created by Fran Alarza on 9/9/22.
//

import Foundation

final class keyChainHelper {
    
    static var standard = keyChainHelper()
    
    private init() {}
    
    func save(_ data: Data, service: String, account: String) {
        let query = [
            kSecValueData: data,
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account
        ] as CFDictionary
        
        let status = SecItemAdd(query, nil)
        
        if status == errSecDuplicateItem {
            updateItems(data: data, account: account, service: service)
        }
        
        if status != errSecSuccess {
            print("The encode process failed")
        }
    }
    
    func read(account: String, service: String) -> Data? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecReturnData: true
        ] as CFDictionary
        
        var result: AnyObject?
        
        SecItemCopyMatching(query, &result)
        return(result as? Data ?? Data())
    }
    
    func delete(account: String, service: String) {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: account,
            kSecAttrService: service
        ] as CFDictionary
        
        SecItemDelete(query)
    }
    
    func save<T:Codable>(item: T, account: String, service: String) {
        do {
            let data = try JSONEncoder().encode(item)
            save(data, service: service, account: account)
        }catch {
            print("The encode process failed")
        }
    }
    
    func read<T: Decodable>(item: T, account: String, service: String, type: T.Type) -> T?{
        guard let data = read(account: account, service: service) else { return nil }
        do{
            let item = try JSONDecoder().decode(type, from: data)
            return item
        }catch {
            return nil
        }
    }
    
    private func updateItems(data: Data, account: String, service: String) {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: account,
            kSecAttrService: service
        ] as CFDictionary
        
        let itemsToUpdate = [kSecValueData: data] as CFDictionary
        SecItemUpdate(query, itemsToUpdate)
    }
}
