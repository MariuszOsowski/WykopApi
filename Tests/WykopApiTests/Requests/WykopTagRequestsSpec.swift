//
//  WykopTagRequestsSpec.swift
//  WykopApi
//
//  Created by Mariusz Osowski on 03/03/2023.
//
//

import Quick
import Nimble
import Foundation

@testable import WykopApi

class WykopTagRequestsSpec: QuickSpec {
    override func spec() {
        describe("WykopTagRequests") {
            context("AutocompleteRequest") {
                var sut: WykopTagRequests.AutocompleteRequest!
                var urlRequest: URLRequest!

                beforeEach {
                    sut = WykopTagRequests.AutocompleteRequest(query: "query-string", authToken: "auth-token")
                    urlRequest = try! sut.urlRequest()
                }

                it("should have correct url") {
                    expect(urlRequest.url?.absoluteString).to(equal("https://wykop.pl/api/v3/tags/autocomplete?query=query-string"))
                }

                it("should have correct method") {
                    expect(urlRequest.httpMethod).to(equal("GET"))
                }

                it("should have Authorization header") {
                    expect(urlRequest.value(forHTTPHeaderField: "Authorization")).to(equal("Bearer auth-token"))
                }

                it("should have correct result type") {
                    expect(WykopTagRequests.AutocompleteRequest.Response.self == [WKPTagShort].self).to(beTrue())
                }
            }

            context("PopularRequest") {
                var sut: WykopTagRequests.PopularRequest!
                var urlRequest: URLRequest!

                beforeEach {
                    sut = WykopTagRequests.PopularRequest(authToken: "auth-token")
                    urlRequest = try! sut.urlRequest()
                }

                it("should have correct url") {
                    expect(urlRequest.url?.absoluteString).to(equal("https://wykop.pl/api/v3/tags/popular"))
                }

                it("should have correct method") {
                    expect(urlRequest.httpMethod).to(equal("GET"))
                }

                it("should have Authorization header") {
                    expect(urlRequest.value(forHTTPHeaderField: "Authorization")).to(equal("Bearer auth-token"))
                }

                it("should have correct result type") {
                    expect(WykopTagRequests.PopularRequest.Response.self == [WKPTag].self).to(beTrue())
                }
            }

            context("DetailsRequest") {
                var sut: WykopTagRequests.DetailsRequest!
                var urlRequest: URLRequest!

                beforeEach {
                    sut = WykopTagRequests.DetailsRequest(tagName: "some-tag", authToken: "auth-token")
                    urlRequest = try! sut.urlRequest()
                }

                it("should have correct url") {
                    expect(urlRequest.url?.absoluteString).to(equal("https://wykop.pl/api/v3/tags/some-tag"))
                }

                it("should have correct method") {
                    expect(urlRequest.httpMethod).to(equal("GET"))
                }

                it("should have Authorization header") {
                    expect(urlRequest.value(forHTTPHeaderField: "Authorization")).to(equal("Bearer auth-token"))
                }

                it("should have correct result type") {
                    expect(WykopTagRequests.DetailsRequest.Response.self == WKPTag.self).to(beTrue())
                }
            }

            context("PopularUserTagsRequest") {
                var sut: WykopTagRequests.PopularUserTagsRequest!
                var urlRequest: URLRequest!

                beforeEach {
                    sut = WykopTagRequests.PopularUserTagsRequest(authToken: "auth-token")
                    urlRequest = try! sut.urlRequest()
                }

                it("should have correct url") {
                    expect(urlRequest.url?.absoluteString).to(equal("https://wykop.pl/api/v3/tags/popular-user-tags"))
                }

                it("should have correct method") {
                    expect(urlRequest.httpMethod).to(equal("GET"))
                }

                it("should have Authorization header") {
                    expect(urlRequest.value(forHTTPHeaderField: "Authorization")).to(equal("Bearer auth-token"))
                }

                it("should have correct result type") {
                    expect(WykopTagRequests.PopularUserTagsRequest.Response.self == [WKPTagShort].self).to(beTrue())
                }
            }

            context("RelatedRequest") {
                var sut: WykopTagRequests.RelatedRequest!
                var urlRequest: URLRequest!

                beforeEach {
                    sut = WykopTagRequests.RelatedRequest(tagName: "some-tag", authToken: "auth-token")
                    urlRequest = try! sut.urlRequest()
                }

                it("should have correct url") {
                    expect(urlRequest.url?.absoluteString).to(equal("https://wykop.pl/api/v3/tags/some-tag/related"))
                }

                it("should have correct method") {
                    expect(urlRequest.httpMethod).to(equal("GET"))
                }

                it("should have Authorization header") {
                    expect(urlRequest.value(forHTTPHeaderField: "Authorization")).to(equal("Bearer auth-token"))
                }

                it("should have correct result type") {
                    expect(WykopTagRequests.RelatedRequest.Response.self == [WKPTagShort].self).to(beTrue())
                }
            }

            context("AuthorsRequest") {
                var sut: WykopTagRequests.AuthorsRequest!
                var urlRequest: URLRequest!

                beforeEach {
                    sut = WykopTagRequests.AuthorsRequest(tagName: "some-tag", authToken: "auth-token")
                    urlRequest = try! sut.urlRequest()
                }

                it("should have correct url") {
                    expect(urlRequest.url?.absoluteString).to(equal("https://wykop.pl/api/v3/tags/some-tag/users"))
                }

                it("should have correct method") {
                    expect(urlRequest.httpMethod).to(equal("GET"))
                }

                it("should have Authorization header") {
                    expect(urlRequest.value(forHTTPHeaderField: "Authorization")).to(equal("Bearer auth-token"))
                }

                it("should have correct result type") {
                    expect(WykopTagRequests.AuthorsRequest.Response.self == [WKPUserShort].self).to(beTrue())
                }
            }
        }
    }
}
