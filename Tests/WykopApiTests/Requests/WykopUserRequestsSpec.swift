//
//  WykopUserRequestsSpec.swift
//  WykopApi
//
//  Created by Mariusz Osowski on 03/03/2023.
//
//

import Quick
import Nimble
import Foundation

@testable import WykopApi

class WykopUserRequestsSpec: QuickSpec {
    override func spec() {
        describe("WykopUsersRequests") {
            context("AutocompleteRequest") {
                var sut: WykopUsersRequests.AutocompleteRequest!
                var urlRequest: URLRequest!

                beforeEach {
                    sut = WykopUsersRequests.AutocompleteRequest(query: "query-string", authToken: "auth-token")
                    urlRequest = try! sut.urlRequest()
                }

                it("should have correct url") {
                    expect(urlRequest.url?.absoluteString).to(equal("https://wykop.pl/api/v3/users/autocomplete?query=query-string"))
                }

                it("should have correct method") {
                    expect(urlRequest.httpMethod).to(equal("GET"))
                }

                it("should have Authorization header") {
                    expect(urlRequest.value(forHTTPHeaderField: "Authorization")).to(equal("Bearer auth-token"))
                }

                it("should have correct result type") {
                    expect(WykopUsersRequests.AutocompleteRequest.Response.self == [WKPUserAutocomplete].self).to(beTrue())
                }
            }
        }
    }
}
