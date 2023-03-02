//
//  TagsAutocompleteRequestTests.swift
//
//
//  Created by Mariusz Osowski on 02/03/2023.
//

import Foundation

import XCTest
@testable import WykopApi

final class TagsAutocompleteRequestTests: XCTestCase {
    func testAutocompleteRequest() throws {
        let urlRequest = try WykopTagRequests.AutocompleteRequest(query: "query-string", authToken: "auth-token").urlRequest()

        XCTAssertEqual(urlRequest.url?.absoluteString, "https://wykop.pl/api/v3/tags/autocomplete?query=query-string")
        XCTAssertEqual(urlRequest.httpMethod, "GET")
        XCTAssertEqual(urlRequest.value(forHTTPHeaderField: "Authorization"), "Bearer auth-token")
        XCTAssert(WykopTagRequests.AutocompleteRequest.Response.self == [WKPTagAutocomplete].self, "Invalid resposne type")
    }

    func testPopularRequest() throws {
        let urlRequest = try WykopTagRequests.PopularRequest(authToken: "test-auth-token").urlRequest()

        XCTAssertEqual(urlRequest.url?.absoluteString, "https://wykop.pl/api/v3/tags/popular")
        XCTAssertEqual(urlRequest.httpMethod, "GET")
        XCTAssertEqual(urlRequest.value(forHTTPHeaderField: "Authorization"), "Bearer test-auth-token")
        XCTAssert(WykopTagRequests.PopularRequest.Response.self == [WKPTag].self, "Invalid resposne type")
    }

    func testDetailsRequest() throws {
        let urlRequest = try WykopTagRequests.DetailsRequest(tagName: "test-tag-name", authToken: "test-auth-token").urlRequest()

        XCTAssertEqual(urlRequest.url?.absoluteString, "https://wykop.pl/api/v3/tags/test-tag-name")
        XCTAssertEqual(urlRequest.httpMethod, "GET")
        XCTAssertEqual(urlRequest.value(forHTTPHeaderField: "Authorization"), "Bearer test-auth-token")
        XCTAssert(WykopTagRequests.DetailsRequest.Response.self == WKPTag.self, "Invalid resposne type")
    }

    func testPopularUserTagsRequest() throws {
        let urlRequest = try WykopTagRequests.PopularUserTagsRequest(authToken: "test-auth-token").urlRequest()

        XCTAssertEqual(urlRequest.url?.absoluteString, "https://wykop.pl/api/v3/tags/popular-user-tags")
        XCTAssertEqual(urlRequest.httpMethod, "GET")
        XCTAssertEqual(urlRequest.value(forHTTPHeaderField: "Authorization"), "Bearer test-auth-token")
        XCTAssert(WykopTagRequests.PopularUserTagsRequest.Response.self == [WKPTagShort].self, "Invalid resposne type")
    }

    func testRelatedRequest() throws {
        let urlRequest = try WykopTagRequests.RelatedRequest(tagName: "test-tag-name", authToken: "test-auth-token").urlRequest()

        XCTAssertEqual(urlRequest.url?.absoluteString, "https://wykop.pl/api/v3/tags/test-tag-name/related")
        XCTAssertEqual(urlRequest.httpMethod, "GET")
        XCTAssertEqual(urlRequest.value(forHTTPHeaderField: "Authorization"), "Bearer test-auth-token")
        XCTAssert(WykopTagRequests.RelatedRequest.Response.self == [WKPTagShort].self, "Invalid resposne type")
    }

    func testAuthorsRequest() throws {
        let urlRequest = try WykopTagRequests.AuthorsRequest(tagName: "test-tag-name", authToken: "test-auth-token").urlRequest()

        XCTAssertEqual(urlRequest.url?.absoluteString, "https://wykop.pl/api/v3/tags/test-tag-name/users")
        XCTAssertEqual(urlRequest.httpMethod, "GET")
        XCTAssertEqual(urlRequest.value(forHTTPHeaderField: "Authorization"), "Bearer test-auth-token")
        XCTAssert(WykopTagRequests.AuthorsRequest.Response.self == [WKPUserShort].self, "Invalid resposne type")
    }
}
