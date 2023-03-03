//
//  TokenSplitterSpec.swift
//  WykopApi
//
//  Created by Mariusz Osowski on 03/03/2023.
//
//

import Quick
import Nimble
import Foundation

@testable import WykopApi

class TokenSplitterSpec: QuickSpec {
    override func spec() {
        describe("TokenSplitter") {
            var sut: TokenSplitter!

            beforeEach {
                sut = TokenSplitter()
            }

            context("when used with invalid token (too short)") {
                it("should return nil") {
                    let payload = sut.getPayload(from: "header.payload")
                    expect(payload).to(beNil())
                }
            }

            context("when used with invalid token (too long)") {
                it("should return nil") {
                    let payload = sut.getPayload(from: "header.payload.signature.other")
                    expect(payload).to(beNil())
                }
            }

            context("when used with correct token") {
                it("should return token payload") {
                    let payload = sut.getPayload(from: "header.some-token-payload.signature")
                    expect(payload).to(equal("some-token-payload"))
                }
            }
        }
    }
}
