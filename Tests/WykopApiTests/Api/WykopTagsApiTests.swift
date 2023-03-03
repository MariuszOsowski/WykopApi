//
//  WykopTagsApiTests.swift
//
//
//  Created by Mariusz Osowski on 25/02/2023.
//

import Foundation

import XCTest
@testable import WykopApi

extension WKPTag: Equatable {
    public static func == (lhs: WKPTag, rhs: WKPTag) -> Bool {
        return lhs.name == rhs.name
    }

    static let mock = WKPTag(createdAt: "test-created-at",
                             name: "test-name",
                             author: nil, personal: true,
                             media: WKPTag.Media(photo: nil),
                             description: "test-description",
                             blacklist: false,
                             editable: true,
                             followers: 200,
                             follow: true,
                             notifications: true,
                             actions: WKPTag.Actions(delete: false,
                                                     createCoauthor: false,
                                                     deleteCoauthor: false,
                                                     update: false,
                                                     blacklist: false))
}

extension WKPTagShort: Equatable {
    public static func == (lhs: WKPTagShort, rhs: WKPTagShort) -> Bool {
        return lhs.name == rhs.name
    }
}

final class WykopTagsApiTests: XCTestCase {
    var sut: WykopTagsApi!
    var mockApiClient: MockApiClient!
    var mockAuthenticationManager: MockAuthenticationManager!

    override func setUp() {
        mockApiClient = MockApiClient()
        mockAuthenticationManager = MockAuthenticationManager()
        sut = WykopTagsApi(apiClient: mockApiClient,
                            authenticationManager: mockAuthenticationManager)
    }

    // MARK: Autocomplete Tests
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
        let apiClientResponse = [WKPTagShort(name: "test-tag")]
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
            let request = mockApiClient.capturedRequest as? WykopTagRequests.AutocompleteRequest
            XCTAssertEqual(request?.authToken, "test-auth-token")
            XCTAssertEqual(request?.query, "test-query")
        } catch {
            didFailWithError = error
        }

        XCTAssertNil(didFailWithError)
    }

    // MARK: Popular Tests
    func testPopularWhenAuthTokenFails() async {
        let authenticationError = NSError(domain: "mock.authentication", code: 0)
        mockAuthenticationManager.tokenStub = .error(authenticationError)
        var didFailWithError: Error?

        do {
            _ = try await sut.popular()
        } catch {
            didFailWithError = error
        }

        XCTAssertEqual(didFailWithError as? NSError, authenticationError)
    }

    func testPopularWhenApiClientTokenFails() async {
        mockAuthenticationManager.tokenStub = .token("test-auth-token")
        let apiClientError = NSError(domain: "mock.apiclient", code: 0)
        mockApiClient.responseStub = .error(apiClientError)
        var didFailWithError: Error?

        do {
            _ = try await sut.popular()
        } catch {
            didFailWithError = error
        }

        XCTAssertEqual(didFailWithError as? NSError, apiClientError)
    }

    func testPopularResult() async {
        mockAuthenticationManager.tokenStub = .token("test-auth-token")
        let apiClientResponse = [WKPTag.mock]
        mockApiClient.responseStub = .value(apiClientResponse)
        var didFailWithError: Error?

        do {
            let result = try await sut.popular()
            XCTAssertEqual(result, apiClientResponse)
        } catch {
            didFailWithError = error
        }

        XCTAssertNil(didFailWithError)
    }

    func testPopularRequest() async {
        mockAuthenticationManager.tokenStub = .token("test-auth-token")
        mockApiClient.responseStub = .value([WKPTag]())
        var didFailWithError: Error?

        do {
            _ = try await sut.popular()
            let request = mockApiClient.capturedRequest as? WykopTagRequests.PopularRequest
            XCTAssertEqual(request?.authToken, "test-auth-token")
        } catch {
            didFailWithError = error
        }

        XCTAssertNil(didFailWithError)
    }

    // MARK: Details Tests
    func testDetailtWhenAuthTokenFails() async {
        let authenticationError = NSError(domain: "mock.authentication", code: 0)
        mockAuthenticationManager.tokenStub = .error(authenticationError)
        var didFailWithError: Error?

        do {
            _ = try await sut.details(tagName: "test-tag")
        } catch {
            didFailWithError = error
        }

        XCTAssertEqual(didFailWithError as? NSError, authenticationError)
    }

    func testDetailsWhenApiClientTokenFails() async {
        mockAuthenticationManager.tokenStub = .token("test-auth-token")
        let apiClientError = NSError(domain: "mock.apiclient", code: 0)
        mockApiClient.responseStub = .error(apiClientError)
        var didFailWithError: Error?

        do {
            _ = try await sut.details(tagName: "test-tag")
        } catch {
            didFailWithError = error
        }

        XCTAssertEqual(didFailWithError as? NSError, apiClientError)
    }

    func testDetailsResult() async {
        mockAuthenticationManager.tokenStub = .token("test-auth-token")
        let apiClientResponse = WKPTag.mock
        mockApiClient.responseStub = .value(apiClientResponse)
        var didFailWithError: Error?

        do {
            let result = try await sut.details(tagName: "test-tag")
            XCTAssertEqual(result, apiClientResponse)
        } catch {
            didFailWithError = error
        }

        XCTAssertNil(didFailWithError)
    }

    func testDetailsRequest() async {
        mockAuthenticationManager.tokenStub = .token("test-auth-token")
        mockApiClient.responseStub = .value(WKPTag.mock)
        var didFailWithError: Error?

        do {
            _ = try await sut.details(tagName: "test-tag")
            let request = mockApiClient.capturedRequest as? WykopTagRequests.DetailsRequest
            XCTAssertEqual(request?.authToken, "test-auth-token")
            XCTAssertEqual(request?.tagName, "test-tag")
        } catch {
            didFailWithError = error
        }

        XCTAssertNil(didFailWithError)
    }

    // MARK: Popular User Tags Tests
    func testPopularUserTagsWhenAuthTokenFails() async {
        let authenticationError = NSError(domain: "mock.authentication", code: 0)
        mockAuthenticationManager.tokenStub = .error(authenticationError)
        var didFailWithError: Error?

        do {
            _ = try await sut.popularUserTags()
        } catch {
            didFailWithError = error
        }

        XCTAssertEqual(didFailWithError as? NSError, authenticationError)
    }

    func testPopularUserTagsWhenApiClientTokenFails() async {
        mockAuthenticationManager.tokenStub = .token("test-auth-token")
        let apiClientError = NSError(domain: "mock.apiclient", code: 0)
        mockApiClient.responseStub = .error(apiClientError)
        var didFailWithError: Error?

        do {
            _ = try await sut.popularUserTags()
        } catch {
            didFailWithError = error
        }

        XCTAssertEqual(didFailWithError as? NSError, apiClientError)
    }

    func testPopularUserTagsResult() async {
        mockAuthenticationManager.tokenStub = .token("test-auth-token")
        let apiClientResponse = [WKPTagShort(name: "test-shotr-tag")]
        mockApiClient.responseStub = .value(apiClientResponse)
        var didFailWithError: Error?

        do {
            let result = try await sut.popularUserTags()
            XCTAssertEqual(result, apiClientResponse)
        } catch {
            didFailWithError = error
        }

        XCTAssertNil(didFailWithError)
    }

    func testPopularUserTagsRequest() async {
        mockAuthenticationManager.tokenStub = .token("test-auth-token")
        mockApiClient.responseStub = .value([WKPTagShort(name: "test-shotr-tag")])
        var didFailWithError: Error?

        do {
            _ = try await sut.popularUserTags()
            let request = mockApiClient.capturedRequest as? WykopTagRequests.PopularUserTagsRequest
            XCTAssertEqual(request?.authToken, "test-auth-token")
        } catch {
            didFailWithError = error
        }

        XCTAssertNil(didFailWithError)
    }

    // MARK: Related Tests
    func testRelatedWhenAuthTokenFails() async {
        let authenticationError = NSError(domain: "mock.authentication", code: 0)
        mockAuthenticationManager.tokenStub = .error(authenticationError)
        var didFailWithError: Error?

        do {
            _ = try await sut.related(tagName: "test-tag")
        } catch {
            didFailWithError = error
        }

        XCTAssertEqual(didFailWithError as? NSError, authenticationError)
    }

    func testRelatedWhenApiClientTokenFails() async {
        mockAuthenticationManager.tokenStub = .token("test-auth-token")
        let apiClientError = NSError(domain: "mock.apiclient", code: 0)
        mockApiClient.responseStub = .error(apiClientError)
        var didFailWithError: Error?

        do {
            _ = try await sut.related(tagName: "test-tag")
        } catch {
            didFailWithError = error
        }

        XCTAssertEqual(didFailWithError as? NSError, apiClientError)
    }

    func testRelatedResult() async {
        mockAuthenticationManager.tokenStub = .token("test-auth-token")
        let apiClientResponse = [WKPTagShort(name: "test-shotr-tag")]
        mockApiClient.responseStub = .value(apiClientResponse)
        var didFailWithError: Error?

        do {
            let result = try await sut.related(tagName: "test-tag")
            XCTAssertEqual(result, apiClientResponse)
        } catch {
            didFailWithError = error
        }

        XCTAssertNil(didFailWithError)
    }

    func testRelatedRequest() async {
        mockAuthenticationManager.tokenStub = .token("test-auth-token")
        mockApiClient.responseStub = .value([WKPTagShort(name: "test-shotr-tag")])
        var didFailWithError: Error?

        do {
            _ = try await sut.related(tagName: "test-tag")
            let request = mockApiClient.capturedRequest as? WykopTagRequests.RelatedRequest
            XCTAssertEqual(request?.authToken, "test-auth-token")
            XCTAssertEqual(request?.tagName, "test-tag")
        } catch {
            didFailWithError = error
        }

        XCTAssertNil(didFailWithError)
    }

    // MARK: Authors Test
    func testAuthorsWhenAuthTokenFails() async {
        let authenticationError = NSError(domain: "mock.authentication", code: 0)
        mockAuthenticationManager.tokenStub = .error(authenticationError)
        var didFailWithError: Error?

        do {
            _ = try await sut.authors(tagName: "test-tag")
        } catch {
            didFailWithError = error
        }

        XCTAssertEqual(didFailWithError as? NSError, authenticationError)
    }

    func testAuthorsdWhenApiClientTokenFails() async {
        mockAuthenticationManager.tokenStub = .token("test-auth-token")
        let apiClientError = NSError(domain: "mock.apiclient", code: 0)
        mockApiClient.responseStub = .error(apiClientError)
        var didFailWithError: Error?

        do {
            _ = try await sut.authors(tagName: "test-tag")
        } catch {
            didFailWithError = error
        }

        XCTAssertEqual(didFailWithError as? NSError, apiClientError)
    }

    func testAuthorsResult() async {
        mockAuthenticationManager.tokenStub = .token("test-auth-token")
        let apiClientResponse = [WKPUserShort.mock]
        mockApiClient.responseStub = .value(apiClientResponse)
        var didFailWithError: Error?

        do {
            let result = try await sut.authors(tagName: "test-tag")
            XCTAssertEqual(result, apiClientResponse)
        } catch {
            didFailWithError = error
        }

        XCTAssertNil(didFailWithError)
    }

    func testAuthorsRequest() async {
        mockAuthenticationManager.tokenStub = .token("test-auth-token")
        mockApiClient.responseStub = .value([WKPUserShort.mock])
        var didFailWithError: Error?

        do {
            _ = try await sut.authors(tagName: "test-tag")
            let request = mockApiClient.capturedRequest as? WykopTagRequests.AuthorsRequest
            XCTAssertEqual(request?.authToken, "test-auth-token")
            XCTAssertEqual(request?.tagName, "test-tag")
        } catch {
            didFailWithError = error
        }

        XCTAssertNil(didFailWithError)
    }

}
