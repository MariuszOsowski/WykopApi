//
//  KeychainWrapper.swift
//  
//
//  Created by Mariusz Osowski on 25/02/2023.
//

import Foundation

protocol KeychainWrapping {
    @discardableResult func save(data: Data, key: String) -> Bool
    @discardableResult func save(string: String, key: String) -> Bool
    @discardableResult func load(key: String) -> Data?
    @discardableResult func loadString(key: String) -> String?
    @discardableResult func delete(key: String) -> Bool
}

final class KeychainWrapper: KeychainWrapping {
    let service: String
    
    init(service: String) {
        self.service = service
    }
    
    @discardableResult func save(data: Data, key: String) -> Bool {
        let query = [
            kSecValueData: data,
            kSecAttrService: service,
            kSecAttrAccount: key,
            kSecClass: kSecClassGenericPassword
        ] as CFDictionary
        
        let status: OSStatus = SecItemAdd(query, nil)
        
        switch status {
        case errSecDuplicateItem:
            return update(data: data, key: key)
        case errSecSuccess:
            return true
        default:
            return false
        }
    }
    
    @discardableResult func save(string: String, key: String) -> Bool {
        guard let data = string.data(using: .utf8) else { return false }
        return save(data: data, key: key)
    }
    
    @discardableResult func load(key: String) -> Data? {
        let query = [
            kSecAttrService: service,
            kSecAttrAccount: key,
            kSecClass: kSecClassGenericPassword,
            kSecReturnData: true
        ] as CFDictionary
        
        var result: AnyObject?
        SecItemCopyMatching(query, &result)
        
        return (result as? Data)
    }
    
    @discardableResult func loadString(key: String) -> String? {
        guard let data = load(key: key) else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
    
    @discardableResult func delete(key: String) -> Bool {
        let query = [
            kSecAttrService: service,
            kSecAttrAccount: key,
            kSecClass: kSecClassGenericPassword,
            ] as CFDictionary
        
        let status: OSStatus = SecItemDelete(query)
        
        if status == errSecSuccess {
            return true
        } else {
            return false
        }
    }
    
    private func update(data: Data, key: String) -> Bool {
        let query = [
            kSecAttrService: service,
            kSecAttrAccount: key,
            kSecClass: kSecClassGenericPassword,
        ] as CFDictionary

        let attributesToUpdate = [kSecValueData: data] as CFDictionary
        
        let status: OSStatus = SecItemUpdate(query, attributesToUpdate)
        
        if status == errSecSuccess {
            return true
        } else {
            return false
        }
    }
}
