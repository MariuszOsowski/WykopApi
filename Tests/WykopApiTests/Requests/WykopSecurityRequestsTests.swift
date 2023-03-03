//
//  WykopSecurityRequestsSpec.swift
//  WykopApi
//
//  Created by Mariusz Osowski on 03/03/2023.
//
//

import Quick
import Nimble
import Foundation

@testable import WykopApi

class WykopSecurityRequestsSpec: QuickSpec {
    override func spec() {
        describe("WykopSecurityRequests") {
            context("AuthRequest") {
                var sut: WykopSecurityRequests.AuthRequest!
                var urlRequest: URLRequest!

                beforeEach {
                    sut = WykopSecurityRequests.AuthRequest(key: "some-key", secret: "some-secret")
                    urlRequest = try! sut.urlRequest()
                }

                it("should have correct url") {
                    expect(urlRequest.url?.absoluteString).to(equal("https://wykop.pl/api/v3/auth"))
                }

                it("should have correct method") {
                    expect(urlRequest.httpMethod).to(equal("POST"))
                }

                it("should have correct httpBody") {
                    expect(urlRequest.httpBody).to(equal("{\"data\":{\"key\":\"some-key\",\"secret\":\"some-secret\"}}".data(using: .utf8)))
                }
            }

            context("RefreshTokenRequest") {
                var sut: WykopSecurityRequests.RefreshTokenRequest!
                var urlRequest: URLRequest!

                beforeEach {
                    sut = WykopSecurityRequests.RefreshTokenRequest(refreshToken: "some-refresh-token")
                    urlRequest = try! sut.urlRequest()
                }

                it("should have correct url") {
                    expect(urlRequest.url?.absoluteString).to(equal("https://wykop.pl/api/v3/refresh-token"))
                }

                it("should have correct method") {
                    expect(urlRequest.httpMethod).to(equal("POST"))
                }

                it("should have correct httpBody") {
                    expect(urlRequest.httpBody).to(equal("{\"data\":{\"refresh_token\":\"some-refresh-token\"}}".data(using: .utf8)))
                }
            }

            context("ConnectRequest") {
                var sut: WykopSecurityRequests.ConnectRequest!
                var urlRequest: URLRequest!

                beforeEach {
                    sut = WykopSecurityRequests.ConnectRequest(authToken: "some-auth-token")
                    urlRequest = try! sut.urlRequest()
                }

                it("should have correct url") {
                    expect(urlRequest.url?.absoluteString).to(equal("https://wykop.pl/api/v3/connect"))
                }

                it("should have correct method") {
                    expect(urlRequest.httpMethod).to(equal("GET"))
                }

                it("should have Authorization header") {
                    expect(urlRequest.value(forHTTPHeaderField: "Authorization")).to(equal("Bearer some-auth-token"))
                }
            }
        }
    }
}
