//
//  WykopApiRequestSpec.swift
//  WykopApi
//
//  Created by Mariusz Osowski on 03/03/2023.
//
//

import Quick
import Nimble
import Foundation

@testable import WykopApi

struct ApiRequestUnderTests: WykopApiRequest {
    typealias Response = String

    var method: HTTPMethod = .DELETE
    var path: String = "/test-endpoint"
    var queryItems: [URLQueryItem]? = [.init(name: "test_query", value: "test_query_value")]
    var headers: [String: String] = ["test_header": "test_value"]
    var requestBody: Encodable?
    var urlBuilder: UrlBuilding?
    var encoder: JSONEncoder?
}

class WykopApiRequestSpec: QuickSpec {
    override func spec() {
        describe("WykopApiRequestSpec") {
            var sut: ApiRequestUnderTests!
            var mockUrlBuilder: MockUrlBuilder!
            var mockJsonEncoder: MockJsonEncoder!

            beforeEach {
                sut = ApiRequestUnderTests()
                mockUrlBuilder = MockUrlBuilder()
                mockJsonEncoder = MockJsonEncoder()

                sut.urlBuilder = mockUrlBuilder
                sut.encoder = mockJsonEncoder
            }

            context("urlRequest callec") {
                context("when urlBuilder fails") {
                    beforeEach {
                        mockUrlBuilder.stubResult = nil
                    }

                    it("should throw error") {
                        expect(try sut.urlRequest()).to(throwError(WykopApiError.invalidUrl))
                    }
                }

                context("when urlBuilder succeeded") {
                    beforeEach {
                        mockUrlBuilder.stubResult = URL(string: "https://wypok.pl/apiV2137/endpoint")!
                    }

                    context("when request body not set") {
                        var returnedValue: URLRequest?

                        beforeEach {
                            sut.requestBody = nil
                            returnedValue = try! sut.urlRequest()
                        }

                        it("should not try to encode body") {
                            expect(mockJsonEncoder.capturedValue).to(beNil())
                        }

                        it("shoudl build url using correct values") {
                            expect(mockUrlBuilder.capturedBasePath).to(equal("https://wykop.pl/api/v3"))
                            expect(mockUrlBuilder.capturedEndpoint).to(equal("/test-endpoint"))
                            expect(mockUrlBuilder.capturedQueryItems).to(equal([.init(name: "test_query", value: "test_query_value")]))
                        }

                        it("should set correct headers") {
                            expect(returnedValue?.value(forHTTPHeaderField: "test_header")).to(equal("test_value"))
                            expect(returnedValue?.value(forHTTPHeaderField: "Accept")).to(equal("application/json"))
                            expect(returnedValue?.value(forHTTPHeaderField: "Content-Type")).to(equal("application/json"))
                        }

                        it("should not set body") {
                            expect(returnedValue?.httpBody).to(beNil())
                        }

                        it("should set correct url") {
                            expect(returnedValue?.url?.absoluteString).to(equal("https://wypok.pl/apiV2137/endpoint"))
                        }
                    }

                    context("when request has body") {
                        beforeEach {
                            sut.requestBody = "body"
                        }

                        context("when encoder fails") {
                            beforeEach {
                                mockJsonEncoder.stubResult = .error(NSError(domain: "wykop.api.request.test", code: 0))
                            }

                            it("should throw error") {
                                expect(try sut.urlRequest()).to(throwError(WykopApiError.encodingError(NSError(domain: "wykop.api.request.test", code: 0))))
                            }
                        }

                        context("when encoder succeeded") {
                            var returnedValue: URLRequest?

                            beforeEach {
                                mockJsonEncoder.stubResult = .success("encodedBody".data(using: .utf8)!)
                                returnedValue = try! sut.urlRequest()
                            }

                            it("shoudl build url using correct values") {
                                expect(mockUrlBuilder.capturedBasePath).to(equal("https://wykop.pl/api/v3"))
                                expect(mockUrlBuilder.capturedEndpoint).to(equal("/test-endpoint"))
                                expect(mockUrlBuilder.capturedQueryItems).to(equal([.init(name: "test_query", value: "test_query_value")]))
                            }

                            it("should encode correct body") {
                                expect(mockJsonEncoder.capturedValue as! String?).to(equal("body"))
                            }

                            it("should set correct headers") {
                                expect(returnedValue?.value(forHTTPHeaderField: "test_header")).to(equal("test_value"))
                                expect(returnedValue?.value(forHTTPHeaderField: "Accept")).to(equal("application/json"))
                                expect(returnedValue?.value(forHTTPHeaderField: "Content-Type")).to(equal("application/json"))
                            }

                            it("should set encoded body") {
                                expect(returnedValue?.httpBody).to(equal("encodedBody".data(using: .utf8)!))
                            }

                            it("should set correct url") {
                                expect(returnedValue?.url?.absoluteString).to(equal("https://wypok.pl/apiV2137/endpoint"))
                            }
                        }
                    }
                }
            }
        }
    }
}
