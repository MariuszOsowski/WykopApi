//
//  WykopUsersApiTests.swift
//
//
//  Created by Mariusz Osowski on 25/02/2023.
//

import Foundation

import XCTest
@testable import WykopApi

extension WKPUserAutocomplete: Equatable {
    public static func == (lhs: WKPUserAutocomplete, rhs: WKPUserAutocomplete) -> Bool {
        return lhs.username == rhs.username &&
        lhs.avatar == rhs.avatar &&
        lhs.color == rhs.color &&
        lhs.gender == rhs.gender
    }
}

final class WykopUsersApiTests: XCTestCase {
    var sut: WykopUsersApi!
    var mockApiClient: MockApiClient!
    var mockAuthenticationManager: MockAuthenticationManager!

    override func setUp() {
        mockApiClient = MockApiClient()
        mockAuthenticationManager = MockAuthenticationManager()
        sut = WykopUsersApi(apiClient: mockApiClient,
                            authenticationManager: mockAuthenticationManager)
    }

    func testAutocompleteWhenAuthTokenFails() async {
        let authenticationError = NSError(domain: "mock.authentication", code: 0)
        mockAuthenticationManager.tokenStub = .error(authenticationError)
        var didFailWithError: Error?

        do {
            _ = try await sut.autocomplete(query: "test-query")
        } catch {
            didFailWithError = error
        }

        XCTAssertEqual(didFailWithError as? NSError, authenticationError)
    }

    func testAutocompleteWhenApiClientTokenFails() async {
        mockAuthenticationManager.tokenStub = .token("test-auth-token")
        let apiClientError = NSError(domain: "mock.apiclient", code: 0)
        mockApiClient.responseStub = .error(apiClientError)
        var didFailWithError: Error?

        do {
            _ = try await sut.autocomplete(query: "test-query")
        } catch {
            didFailWithError = error
        }

        XCTAssertEqual(didFailWithError as? NSError, apiClientError)
    }

    func testAutocompleteResult() async {
        mockAuthenticationManager.tokenStub = .token("test-auth-token")
        let apiClientResponse = [WKPUserAutocomplete(username: "Test User", gender: "Test Gender", color: "Test Color", avatar: "Test Avatar URL")]
        mockApiClient.responseStub = .value(apiClientResponse)
        var didFailWithError: Error?

        do {
            let result = try await sut.autocomplete(query: "test-query")
            XCTAssertEqual(result, apiClientResponse)
        } catch {
            didFailWithError = error
        }

        XCTAssertNil(didFailWithError)
    }

    func testAutoCompleteRequest() async {
        mockAuthenticationManager.tokenStub = .token("test-auth-token")
        mockApiClient.responseStub = .value([WKPUserAutocomplete]())
        var didFailWithError: Error?

        do {
            _ = try await sut.autocomplete(query: "test-query")
            let request = mockApiClient.capturedRequest as? WykopUsersRequests.AutocompleteRequest
            XCTAssertEqual(request?.authToken, "test-auth-token")
            XCTAssertEqual(request?.query, "test-query")
        } catch {
            didFailWithError = error
        }

        XCTAssertNil(didFailWithError)
    }
}
