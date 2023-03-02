//
//  WykopUserRequestsTests.swift
//
//
//  Created by Mariusz Osowski on 02/03/2023.
//

import Foundation

import XCTest
@testable import WykopApi

final class WykopUserRequestsTests: XCTestCase {
    func testAutocompleteRequest() throws {
        let urlRequest = try WykopUsersRequests.AutocompleteRequest(query: "query-string", authToken: "auth-token").urlRequest()

        XCTAssertEqual(urlRequest.url?.absoluteString, "https://wykop.pl/api/v3/users/autocomplete?query=query-string")
        XCTAssertEqual(urlRequest.httpMethod, "GET")
        XCTAssertEqual(urlRequest.value(forHTTPHeaderField: "Authorization"), "Bearer auth-token")
        XCTAssert(WykopUsersRequests.AutocompleteRequest.Response.self == [WKPUserAutocomplete].self, "Invalid resposne type")
    }
}
