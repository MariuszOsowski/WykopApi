//
//  TokenDecoderTests.swift
//
//
//  Created by Mariusz Osowski on 25/02/2023.
//

import Foundation

import XCTest
@testable import WykopApi

final class TokenDecoderTests: XCTestCase {
    static let userToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VybmFtZSI6IlRlc3RVc2VyIiwidXNlci1pcCI6InRlc3QtdXNlci1pcCIsInJvbGVzIjpbIlJPTEVfVVNFUiJdLCJhcHAta2V5IjoidGVzdC1hcHAta2V5IiwiZXhwIjoxNjc2OTk0NzA4fQ.pjDO9xxJ_xtVuCv_0ITlQ-w0NKyoXvpyVS2owFUZ7EI"
    
    static let appToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VybmFtZSI6InRlc3QtYXBwLWtleSIsInVzZXItaXAiOiJ0ZXN0LXVzZXItaXAiLCJyb2xlcyI6WyJST0xFX0FQUCJdLCJhcHAta2V5IjoidGVzdC1hcHAta2V5IiwiZXhwIjoxNjc3MTY1NTYyfQ.S3sfntLJJ-4efmv4omuRSrGysF-wXpiR8QXIvHx2PaQ"
    
    static let invalidToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VybmFtZSI6InRlc3QtYXBwLWtleSIsInVzZXItaXAiOiJ0ZXN0LXVzZXItaXAiLCJyb2xlcyI6WyJST0xFX0FQUCJdLCJhcHAta2V5IjoidGVzdC1hcHAta2V5IiwiZXhwIjoxNjc3MTY1NTYyfQ"
    
    static let invalidPayloadToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VybmtZSI6InRlc3QtYXBwLWtleSIsInVzZXItaXAiOiJ0ZXN0LXVzZXItaXAiLCJyb2xlcyI6WyJST0xFX0FQUCJdLCJhcHAta2V5IjoidGVzdC1hcHAta2V5IiwiZXhwIjoxNjc3MTY1NTYyfQ.S3sfntLJJ-4efmv4omuRSrGysF-wXpiR8QXIvHx2PaQ"
    
    
    func testUserTokenDecode() {
        let tokenPayload = try! TokenDecoder().decodePayload(token: Self.userToken)
        XCTAssertEqual(tokenPayload.username, "TestUser")
        XCTAssertEqual(tokenPayload.expiryDate.timeIntervalSince1970, 1676994708.0)
        XCTAssertTrue(tokenPayload.roles.contains("ROLE_USER"))
    }
    
    func testAppTokenDecode() {
        let tokenPayload = try! TokenDecoder().decodePayload(token: Self.appToken)
        XCTAssertEqual(tokenPayload.username, "test-app-key")
        XCTAssertEqual(tokenPayload.expiryDate.timeIntervalSince1970, 1677165562)
        XCTAssertTrue(tokenPayload.roles.contains("ROLE_APP"))
    }
    
    func testInvalidToken() {
        XCTAssertThrowsError(try TokenDecoder().decodePayload(token: Self.invalidToken)) { (error) in
            XCTAssertEqual(error as? TokenDecoderError, TokenDecoderError.invalidToken)
        }
    }
    
    func testInvalidPayload() {
        XCTAssertThrowsError(try TokenDecoder().decodePayload(token: Self.invalidPayloadToken)) { (error) in
            XCTAssertEqual(error as? TokenDecoderError, TokenDecoderError.decodingError)
        }
    }
}
