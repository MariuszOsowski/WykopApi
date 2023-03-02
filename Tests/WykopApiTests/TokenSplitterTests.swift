//
//  TokenSplitterTest.swift
//  
//
//  Created by Mariusz Osowski on 02/03/2023.
//

import Foundation

import XCTest
@testable import WykopApi

final class TokenSplitterTest: XCTestCase {
    func testShortToken() {
        let payload = TokenSplitter().getPayload(from: "header.payload")
        XCTAssertNil(payload)
    }

    func testLongToken() {
        let payload = TokenSplitter().getPayload(from: "header.payload.signature.other")
        XCTAssertNil(payload)
    }

    func testCorrectToken() {
        let payload = TokenSplitter().getPayload(from: "header.payload.signature")
        XCTAssertEqual(payload, "payload")
    }
}
