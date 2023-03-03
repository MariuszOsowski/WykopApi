//
//  WykopDecoderSpec.swift
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

class WykopDecoderSpec: QuickSpec {
    override func spec() {
        describe("WykopDecoder") {
            var sut: JSONDecoder!

            beforeEach {
                sut = JSONDecoder.wykopDecoder
            }

            it("shoud have correct decoding stragegy") {
                guard case JSONDecoder.KeyDecodingStrategy.convertFromSnakeCase = sut.keyDecodingStrategy else {
                    XCTFail("Invalid decoding strategy")
                    return
                }
            }
        }
    }
}
