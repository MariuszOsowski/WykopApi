//
//  KeychainWrapperTests.swift
//  
//
//  Created by Mariusz Osowski on 25/02/2023.
//

import Foundation

import XCTest
@testable import WykopApi

final class KeychainWrapperTests: XCTestCase {
    static let testServiceName = "WrapperTestignService"
    static let testKey = "WrapperTestignKey"
    static let testValue = "SomeSecretKey"
    static let testUpdatedValue = "SomeUpdatedSecretKey"

    override class func setUp() {
        Keychain(service: testServiceName).delete(key: testKey)
    }

    func testKeychain() throws {
        // Save value
        Keychain(service: Self.testServiceName).save(data: Self.testValue.data(using: .utf8)!, key: Self.testKey)
        let value = Keychain(service: Self.testServiceName).load(key: Self.testKey)!
        XCTAssertEqual(String(data: value, encoding: .utf8)!, Self.testValue)

        // Update value
        Keychain(service: Self.testServiceName).save(data: Self.testUpdatedValue.data(using: .utf8)!, key: Self.testKey)
        let updatedValue = Keychain(service: Self.testServiceName).load(key: Self.testKey)!
        XCTAssertEqual(String(data: updatedValue, encoding: .utf8)!, Self.testUpdatedValue)

        // Delete value
        Keychain(service: Self.testServiceName).delete(key: Self.testKey)
        let deletedValue = Keychain(service: Self.testServiceName).load(key: Self.testKey)
        XCTAssertNil(deletedValue)
    }

    func testKeychainStrings() throws {
        // Save value
        Keychain(service: Self.testServiceName).save(string: Self.testValue, key: Self.testKey)
        let value = Keychain(service: Self.testServiceName).loadString(key: Self.testKey)!
        XCTAssertEqual(value, Self.testValue)

        // Update value
        Keychain(service: Self.testServiceName).save(string: Self.testUpdatedValue, key: Self.testKey)
        let updatedValue = Keychain(service: Self.testServiceName).loadString(key: Self.testKey)!
        XCTAssertEqual(updatedValue, Self.testUpdatedValue)

        // Delete value
        Keychain(service: Self.testServiceName).delete(key: Self.testKey)
        let deletedValue = Keychain(service: Self.testServiceName).loadString(key: Self.testKey)
        XCTAssertNil(deletedValue)
    }
}
