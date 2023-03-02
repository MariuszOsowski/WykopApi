//
//  TokenDecoderTests.swift
//
//
//  Created by Mariusz Osowski on 25/02/2023.
//

import Foundation

import XCTest
@testable import WykopApi

extension TokenPayload: Equatable {
    static public func == (lhs: TokenPayload, rhs: TokenPayload) -> Bool {
        return lhs.username == rhs.username && lhs.expiryDate == rhs.expiryDate && lhs.roles == rhs.roles
    }
}

final class TokenDecoderTests: XCTestCase {
    var sut: TokenDecoder!
    var mockJsonDecoder: MockJsonDecoder<TokenPayload>!
    var mockBase64Decoder: MockBase64Decoder!
    var mockTokenSplitter: MockTokenSplitter!

    override func setUp() {
        mockJsonDecoder = MockJsonDecoder<TokenPayload>()
        mockBase64Decoder = MockBase64Decoder()
        mockTokenSplitter = MockTokenSplitter()
        sut = TokenDecoder(jsonDecoder: mockJsonDecoder,
                           base64Decoder: mockBase64Decoder,
                           tokenSplitter: mockTokenSplitter)
    }

    func testInvalidTokenStructureDecode() {
        mockTokenSplitter.stubResult = nil

        XCTAssertThrowsError(try sut.decodePayload(token: "test-token")) { (error) in
            XCTAssertEqual(mockTokenSplitter.capturedToken, "test-token", "Invalid token passed to tokenSplitter")
            XCTAssertNil(mockBase64Decoder.capturedBase64, "Should not try to decode base64 payload")
            XCTAssertNil(mockJsonDecoder.caputuredData, "Should not try to decode json payload")
            XCTAssertEqual(error as? TokenDecoderError, TokenDecoderError.invalidToken)
        }
    }

    func testInvalidBase64Paylaod() {
        mockTokenSplitter.stubResult = "base64-decoded-payload"
        mockBase64Decoder.stubResult = nil

        XCTAssertThrowsError(try sut.decodePayload(token: "test-token")) { (error) in
            XCTAssertEqual(mockBase64Decoder.capturedBase64, "base64-decoded-payload", "Should pass payload from token splitter to base64Decoder")
            XCTAssertNil(mockJsonDecoder.caputuredData, "Should not try to decode json payload")
            XCTAssertEqual(error as? TokenDecoderError, TokenDecoderError.invalidToken)
        }
    }

    func testJsonDecodingError() {
        let mockJsonData = "mock-json".data(using: .utf8)
        mockTokenSplitter.stubResult = "base64-decoded-payload"
        mockBase64Decoder.stubResult = mockJsonData
        mockJsonDecoder.stubResult = .error(NSError(domain: "token.decoder.test", code: 0))

        XCTAssertThrowsError(try sut.decodePayload(token: "test-token")) { (error) in
            XCTAssertEqual(mockJsonDecoder.caputuredData, mockJsonData, "Should pass base64 decoded payload to json decoder")
            XCTAssertEqual(error as? TokenDecoderError, TokenDecoderError.decodingError)
        }
    }

    func testSuccessfulDecoding() throws {
        let mockJsonData = "mock-json".data(using: .utf8)
        let mockPayload = TokenPayload(username: "", expiryDate: Date(), roles: ["d"])
        mockTokenSplitter.stubResult = "base64-decoded-payload"
        mockBase64Decoder.stubResult = mockJsonData
        mockJsonDecoder.stubResult = .success(mockPayload)

        let payload = try sut.decodePayload(token: "test-token")
        XCTAssertEqual(mockJsonDecoder.caputuredData, mockJsonData, "Should pass base64 decoded payload to json decoder")
        XCTAssertEqual(payload, mockPayload, "Should return decoded payload")
    }
}
