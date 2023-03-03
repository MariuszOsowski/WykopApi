//
//  TokenPayloadSpec.swift
//  WykopApi
//
//  Created by Mariusz Osowski on 03/03/2023.
//
//

import Quick
import Nimble
import Foundation
import XCTest

@testable import WykopApi

class TokenPayloadSpec: QuickSpec {
    override func spec() {
        describe("TokenPayload") {
            var sut: TokenPayload!

            context("when created with decoder") {
                beforeEach {
                    let json = "{\"username\": \"user\",  \"roles\": [\"ROLE_1\"],  \"exp\": 1676994708}"
                    sut = try! JSONDecoder.wykopDecoder.decode(TokenPayload.self, from: json.data(using: .utf8)!)
                }

                it("should have correct username") {
                    expect(sut.username).to(equal("user"))
                }

                it("should have correct username") {
                    expect(sut.roles).to(equal(["ROLE_1"]))
                }

                it("should have correct expiryDate") {
                    expect(sut.expiryDate).to(equal(Date(timeIntervalSince1970: 1676994708)))
                }
            }
        }
    }
}
