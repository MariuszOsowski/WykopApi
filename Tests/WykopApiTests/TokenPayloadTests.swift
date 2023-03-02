//
//  TokenPayloadTests.swift
//  
//
//  Created by Mariusz Osowski on 02/03/2023.
//

import Foundation

import XCTest
@testable import WykopApi

final class TokenPayloadTests: XCTestCase {
    func testTokenPayloadDecoding() throws {
        let json = "{\"username\": \"user\",  \"roles\": [\"ROLE_1\"],  \"exp\": 1676994708}"
        let payload: TokenPayload = try JSONDecoder().decode(TokenPayload.self, from: json.data(using: .utf8)!)

        XCTAssertEqual(payload.username, "user")
        XCTAssertEqual(payload.roles, ["ROLE_1"])
        XCTAssertEqual(payload.expiryDate, Date(timeIntervalSince1970: 1676994708))
    }
}
