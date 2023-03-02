//
//  Base64DecoderTests.swift
//
//
//  Created by Mariusz Osowski on 02/03/2023.
//

import Foundation

import XCTest
@testable import WykopApi

final class Base64DecoderTests: XCTestCase {
    func testBase64Decoding() {
        let decoded = Base64Decoder().decode(base64: "TG9yZW0gaXBzdW0gZG9sb3Igc2l0IGFtZXQ")!
        XCTAssertEqual(String(data: decoded, encoding: .utf8), "Lorem ipsum dolor sit amet")
    }
}
