//
//  TokenValidatorSpec.swift
//  WykopApi
//
//  Created by Mariusz Osowski on 01/04/2023.
//
//

import Foundation
import Quick
import Nimble

@testable import WykopApi

class TokenValidatorSpec: QuickSpec {
    override func spec() {
        describe("TokenValidator") {
            var tokenValidator: TokenValidator!
            var tokenDecoder: MockTokenDecoder!

            beforeEach {
                tokenDecoder = MockTokenDecoder()
                tokenValidator = TokenValidator(tokenDecoder: tokenDecoder)
            }

            context("when token is valid") {
                it("returns true") {
                    let validToken = "validToken"
                    let validPayload = TokenPayload(username: "", expiryDate: Date(timeIntervalSinceNow: 600), roles: [])
                    tokenDecoder.stubResult = .payload(validPayload)

                    expect(tokenValidator.isValid(token: validToken)).to(beTrue())
                    expect(tokenDecoder.token).to(equal(validToken))
                }
            }

            context("when token is invalid") {
                it("returns false") {
                    let invalidToken = "invalidToken"
                    tokenDecoder.stubResult = .error(MockTokenDecoder.MockError.decodingError)

                    expect(tokenValidator.isValid(token: invalidToken)).to(beFalse())
                    expect(tokenDecoder.token).to(equal(invalidToken))
                }
            }

            context("when token is expired") {
                it("returns false") {
                    let expiredToken = "expiredToken"
                    let expiredPayload = TokenPayload(username: "", expiryDate: Date(timeIntervalSinceNow: -600), roles: [])
                    tokenDecoder.stubResult = .payload(expiredPayload)

                    expect(tokenValidator.isValid(token: expiredToken)).to(beFalse())
                    expect(tokenDecoder.token).to(equal(expiredToken))
                }
            }
        }
    }
}
