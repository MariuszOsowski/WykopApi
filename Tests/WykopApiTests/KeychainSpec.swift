//
//  KeychainSpec.swift
//  WykopApi
//
//  Created by Mariusz Osowski on 03/03/2023.
//
//

import Quick
import Nimble
import Foundation

@testable import WykopApi

class KeychainSpec: QuickSpec {
    static let serviceName = "KeychainWrapperSpecService"
    static let testKey = "TestKey"

    override func spec() {
        describe("Keychain") {
            var sut: Keychain!

            beforeEach {
                sut = Keychain(service: Self.serviceName)
                sut.delete(key: Self.testKey)
            }

            describe("Data Handling") {
                context("when data saved for the first time") {
                    let testData = "some secret value".data(using: .utf8)!

                    beforeEach {
                        sut.save(data: testData, key: Self.testKey)
                    }

                    it("it should load correct data") {
                        expect(sut.load(key: Self.testKey)).to(equal(testData))
                    }

                    context("when data saved again") {
                        let newData = "some new secret value".data(using: .utf8)!

                        beforeEach {
                            sut.save(data: newData, key: Self.testKey)
                        }

                        it("it should load updated data") {
                            expect(sut.load(key: Self.testKey)).to(equal(newData))
                        }

                        context("when data deleted") {
                            beforeEach {
                                sut.delete(key: Self.testKey)
                            }

                            it("it should load nil") {
                                expect(sut.load(key: Self.testKey)).to(beNil())
                            }
                        }
                    }
                }
            }

            describe("String Handling") {
                context("when string saved for the first time") {
                    let testString = "some secret string"

                    beforeEach {
                        sut.save(string: testString, key: Self.testKey)
                    }

                    it("it should load correct data") {
                        expect(sut.loadString(key: Self.testKey)).to(equal(testString))
                    }

                    context("when string saved again") {
                        let newString = "some new secret string"

                        beforeEach {
                            sut.save(string: newString, key: Self.testKey)
                        }

                        it("it should load updated string") {
                            expect(sut.loadString(key: Self.testKey)).to(equal(newString))
                        }

                        context("when data deleted") {
                            beforeEach {
                                sut.delete(key: Self.testKey)
                            }

                            it("it should load nil") {
                                expect(sut.loadString(key: Self.testKey)).to(beNil())
                            }
                        }
                    }
                }
            }
        }
    }
}
