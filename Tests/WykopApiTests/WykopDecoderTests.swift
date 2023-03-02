//
//  WykopDecoderTests.swift
//  
//
//  Created by Mariusz Osowski on 02/03/2023.
//

import Foundation

import XCTest
@testable import WykopApi

final class WykopDecoderTests: XCTestCase {
    func testKeyDecodingStrategy() throws {
        let decoder = JSONDecoder.wykopDecoder

        guard case JSONDecoder.KeyDecodingStrategy.convertFromSnakeCase = decoder.keyDecodingStrategy else {
            XCTFail()
            return
        }
    }
}
