//
//  KeychainWrapper.swift
//  
//
//  Created by Mariusz Osowski on 25/02/2023.
//

import Foundation

protocol KeyStoring {
    func save(data: Data, key: String)
    func save(string: String, key: String)
    func load(key: String) -> Data?
    func loadString(key: String) -> String?
    func delete(key: String)
}

final class Keychain: KeyStoring {
    let service: String

    init(service: String) {
        self.service = service
    }

    func save(data: Data, key: String) {
        let query = [
            kSecValueData: data,
            kSecAttrService: service,
            kSecAttrAccount: key,
            kSecClass: kSecClassGenericPassword
        ] as CFDictionary

        if SecItemAdd(query, nil) == errSecDuplicateItem {
            update(data: data, key: key)
        }
    }

    func save(string: String, key: String) {
        guard let data = string.data(using: .utf8) else { return }
        return save(data: data, key: key)
    }

    func load(key: String) -> Data? {
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

    func loadString(key: String) -> String? {
        guard let data = load(key: key) else {
            return nil
        }

        return String(data: data, encoding: .utf8)
    }

    func delete(key: String) {
        let query = [
            kSecAttrService: service,
            kSecAttrAccount: key,
            kSecClass: kSecClassGenericPassword
            ] as CFDictionary

        SecItemDelete(query)
    }

    private func update(data: Data, key: String) {
        let query = [
            kSecAttrService: service,
            kSecAttrAccount: key,
            kSecClass: kSecClassGenericPassword
        ] as CFDictionary

        let attributesToUpdate = [kSecValueData: data] as CFDictionary
        SecItemUpdate(query, attributesToUpdate)
    }
}
