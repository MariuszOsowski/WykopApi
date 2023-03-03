//
//  TokenDecoderSpec.swift
//  WykopApi
//
//  Created by Mariusz Osowski on 03/03/2023.
//
//

import Foundation
import Quick
import Nimble

@testable import WykopApi

extension TokenPayload: Equatable {
    static public func == (lhs: TokenPayload, rhs: TokenPayload) -> Bool {
        return lhs.username == rhs.username && lhs.expiryDate == rhs.expiryDate && lhs.roles == rhs.roles
    }
}

class TokenDecoderSpec: QuickSpec {
    override func spec() {
        var sut: TokenDecoder!
        var mockJsonDecoder: MockJsonDecoder<TokenPayload>!
        var mockBase64Decoder: MockBase64Decoder!
        var mockTokenSplitter: MockTokenSplitter!

        describe("TokenDecoder") {
            beforeEach {
                mockJsonDecoder = MockJsonDecoder<TokenPayload>()
                mockBase64Decoder = MockBase64Decoder()
                mockTokenSplitter = MockTokenSplitter()
                sut = TokenDecoder(jsonDecoder: mockJsonDecoder,
                                   base64Decoder: mockBase64Decoder,
                                   tokenSplitter: mockTokenSplitter)
            }

            context("when decoding token") {
                context("when splitter fails") {
                    beforeEach {
                        mockTokenSplitter.stubResult = nil
                    }

                    it("should pass correct token to splitter") {
                        _ = try? sut.decodePayload(token: "some-auth-token")
                        expect(mockTokenSplitter.capturedToken).to(equal("some-auth-token"))
                    }

                    it("should not try to decode base64 payload") {
                        _ = try? sut.decodePayload(token: "some-auth-token")
                        expect(mockBase64Decoder.capturedBase64).to(beNil())
                    }

                    it("Should not try to decode json payload") {
                        _ = try? sut.decodePayload(token: "some-auth-token")
                        expect(mockJsonDecoder.caputuredData).to(beNil())
                    }

                    it("should throw invalidTokenError") {
                        expect(try sut.decodePayload(token: "some-auth-token")).to(throwError(TokenDecoderError.invalidToken))
                    }
                }

                context("when splitter succeeded") {
                    beforeEach {
                        mockTokenSplitter.stubResult = "some-base64-encoded-payload"
                    }

                    context("when base64 decoder fails") {
                        beforeEach {
                            mockBase64Decoder.stubResult = nil
                        }

                        it("should try to decode base64 payload") {
                            _ = try? sut.decodePayload(token: "some-auth-token")
                            expect(mockBase64Decoder.capturedBase64).to(equal("some-base64-encoded-payload"))
                        }

                        it("Should not try to decode json payload") {
                            _ = try? sut.decodePayload(token: "some-auth-token")
                            expect(mockJsonDecoder.caputuredData).to(beNil())
                        }

                        it("should throw invalidTokenError") {
                            expect(try sut.decodePayload(token: "some-auth-token")).to(throwError(TokenDecoderError.invalidToken))
                        }
                    }

                    context("when base64 decoder succeeded") {
                        beforeEach {
                            mockBase64Decoder.stubResult = "some-decoded-payload".data(using: .utf8)
                        }

                        context("when json decoder fails") {
                            beforeEach {
                                mockJsonDecoder.stubResult = .error(NSError(domain: "token.decoder.test", code: 0))
                            }

                            it("Should try to decode json payload") {
                                _ = try? sut.decodePayload(token: "some-auth-token")
                                expect(mockJsonDecoder.caputuredData).to(equal("some-decoded-payload".data(using: .utf8)!))
                            }

                            it("should throw invalidTokenError") {
                                expect(try sut.decodePayload(token: "some-auth-token")).to(throwError(TokenDecoderError.decodingError))
                            }
                        }

                        context("when json decoder succeeded") {
                            let mockPayload = TokenPayload(username: "username", expiryDate: Date(), roles: ["d"])

                            beforeEach {
                                mockJsonDecoder.stubResult = .success(mockPayload)
                            }

                            it("return decoded payload") {
                                expect(try sut.decodePayload(token: "some-auth-token")).to(equal(mockPayload))
                            }
                        }
                    }
                }
            }
        }
    }
}
