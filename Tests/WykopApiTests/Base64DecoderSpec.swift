//
//  Base64DecoderSpec.swift
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

class Base64DecoderSpec: QuickSpec {
    override func spec() {
        describe("Base64Decoder") {
            var sut: Base64Decoder!

            beforeEach {
                sut = Base64Decoder()
            }

            context("when decoding") {
                context("base64 without paddign") {
                    it("shoud decode correct data") {
                        let decoded = sut.decode(base64: "TG9yZW0gaXBzdW0gZG9sb3Igc2l0IGFtZXQ")
                        expect(decoded).to(equal("Lorem ipsum dolor sit amet".data(using: .utf8)))
                    }
                }

                context("base64 with paddign") {
                    it("shoud decode correct data") {
                        let decoded = sut.decode(base64: "TG9yZW0gaXBzdW0gZG9sb3Igc2l0IGFtZXQ=")
                        expect(decoded).to(equal("Lorem ipsum dolor sit amet".data(using: .utf8)))
                    }
                }

                context("invalid base64") {
                    it("shoud return nil") {
                        let decoded = sut.decode(base64: "TG9yZW0gaXBzdW0gZG9sb3Igc2l0IGFtZXQ^^")
                        expect(decoded).to(beNil())
                    }
                }
            }
        }
    }
}
