//
//  TokenValidatorTests.swift
//  
//
//  Created by Mariusz Osowski on 25/02/2023.
//

import Foundation

import XCTest
@testable import WykopApi

final class TokenValidatorTests: XCTestCase {
    func testTokenDecoding() {
        let mockTokenDecoder = MockTokenDecoder()
        _ = TokenValidator(tokenDecoder: mockTokenDecoder).isValid(token: "token")

        XCTAssertEqual(mockTokenDecoder.token, "token")
    }

    func testInvalidTokenValidation() {
        let mockTokenDecoder = MockTokenDecoder()
        let isValid = TokenValidator(tokenDecoder: mockTokenDecoder).isValid(token: "token")

        XCTAssertFalse(isValid)
    }

    func testNotExpitedToken() {
        let mockTokenDecoder = MockTokenDecoder()
        mockTokenDecoder.stubResult = .payload(TokenPayload(username: "", expiryDate: Date(timeIntervalSinceNow: 3600), roles: []))

        let isValid = TokenValidator(tokenDecoder: mockTokenDecoder).isValid(token: "token")

        XCTAssertTrue(isValid)
    }

    func testExpitedToken() {
        let mockTokenDecoder = MockTokenDecoder()
        mockTokenDecoder.stubResult = .payload(TokenPayload(username: "", expiryDate: Date(timeIntervalSinceNow: 100), roles: []))

        let isValid = TokenValidator(tokenDecoder: mockTokenDecoder).isValid(token: "token")

        XCTAssertFalse(isValid)
    }
}
