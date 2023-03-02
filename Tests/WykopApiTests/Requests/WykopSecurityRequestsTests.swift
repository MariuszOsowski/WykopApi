//
//  WykopSecurityRequestsTests.swift
//
//
//  Created by Mariusz Osowski on 02/03/2023.
//

import Foundation

import XCTest
@testable import WykopApi

final class WykopSecurityRequestsTests: XCTestCase {
    func testAuthRequest() throws {
        let urlRequest = try WykopSecurityRequests.AuthRequest(key: "test-key", secret: "test-secret").urlRequest()

        XCTAssertEqual(urlRequest.url?.absoluteString, "https://wykop.pl/api/v3/auth")
        XCTAssertEqual(urlRequest.httpMethod, "POST")
        XCTAssertEqual(String(data: urlRequest.httpBody!, encoding: .utf8), "{\"data\":{\"key\":\"test-key\",\"secret\":\"test-secret\"}}")
    }

    func testRefreshTokenRequest() throws {
        let urlRequest = try WykopSecurityRequests.RefreshTokenRequest(refreshToken: "test-refresh-token").urlRequest()

        XCTAssertEqual(urlRequest.url?.absoluteString, "https://wykop.pl/api/v3/refresh-token")
        XCTAssertEqual(urlRequest.httpMethod, "POST")
        XCTAssertEqual(String(data: urlRequest.httpBody!, encoding: .utf8), "{\"data\":{\"refresh_token\":\"test-refresh-token\"}}")
    }

    func testConnectRequest() throws {
        let urlRequest = try WykopSecurityRequests.ConnectRequest(authToken: "test-auth-token").urlRequest()

        XCTAssertEqual(urlRequest.url?.absoluteString, "https://wykop.pl/api/v3/connect")
        XCTAssertEqual(urlRequest.httpMethod, "GET")
        XCTAssertEqual(urlRequest.value(forHTTPHeaderField: "Authorization"), "Bearer test-auth-token")
    }
}
