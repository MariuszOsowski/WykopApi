//
//  WykopApiTest.swift
//
//
//  Created by Mariusz Osowski on 25/02/2023.
//

import Foundation

import XCTest
@testable import WykopApi

final class WykopApiTest: XCTestCase {
    var sut: WykopApi!
    var mockApiClient: MockApiClient!
    var mockAuthenticationManager: MockAuthenticationManager!
    var mockLoginDelegate: MockLoginDelegate!

    override func setUp() {
        mockApiClient = MockApiClient()
        mockAuthenticationManager = MockAuthenticationManager()
        mockLoginDelegate = MockLoginDelegate()
        sut = WykopApi(apiClient: mockApiClient, authenticationManager: mockAuthenticationManager)
    }

    // MARK: Login Tests
    func testLoginWithNoDelegate() async {
        do {
            try await sut.login()
            XCTAssertEqual(mockAuthenticationManager.authTokenCallCounter, 0, "Should not get auth token")
            XCTAssertNil(mockApiClient.capturedRequest, "Should not call api")
        } catch {
            XCTFail("Should not throw error")
        }
    }

    func testLoginWhenAuthTokenFails() async {
        let authenticationError = NSError(domain: "mock.authentication", code: 0)
        mockAuthenticationManager.tokenStub = .error(authenticationError)
        sut.delegate = mockLoginDelegate

        var didFailWithError: Error?

        do {
            try await sut.login()
            XCTAssertNil(mockApiClient.capturedRequest, "Should not call api")
            XCTAssertNil(mockLoginDelegate.connectUrl, "Should not call delegate")
            XCTAssertNil(mockLoginDelegate.callback, "Should not call delegate")
            XCTAssertFalse(mockLoginDelegate.loginCompleted, "Should not complete login")
        } catch {
            didFailWithError = error
        }

        XCTAssertEqual(didFailWithError as? NSError, authenticationError, "Should throw authentication error")
    }

    func testLoginWhenApiClientFails() async {
        let apiClientError = NSError(domain: "mock.api", code: 0)
        mockAuthenticationManager.tokenStub = .token("test-token")
        mockApiClient.responseStub = .error(apiClientError)
        sut.delegate = mockLoginDelegate

        var didFailWithError: Error?

        do {
            try await sut.login()
            XCTAssertNil(mockLoginDelegate.connectUrl, "Should not call delegate")
            XCTAssertNil(mockLoginDelegate.callback, "Should not call delegate")
            XCTAssertFalse(mockLoginDelegate.loginCompleted, "Should not complete login")
        } catch {
            didFailWithError = error
        }

        XCTAssertEqual(didFailWithError as? NSError, apiClientError, "Should throw api client error")
    }

    func testLogin() async {
        mockAuthenticationManager.tokenStub = .token("test-token")
        mockApiClient.responseStub = .value(WykopSecurityRequests.ConnectRequest.Response(connectUrl: "http://test.connect.url"))
        sut.delegate = mockLoginDelegate

        var didFailWithError: Error?

        do {
            try await sut.login()
            XCTAssertEqual(mockLoginDelegate.connectUrl, "http://test.connect.url", "Invalid connect url")
            XCTAssertNotNil(mockLoginDelegate.callback, "Should call delegate with callback")
            XCTAssertFalse(mockLoginDelegate.loginCompleted, "Should not complete login")
        } catch {
            didFailWithError = error
        }

        XCTAssertNil(didFailWithError, "Should not throw error")
    }

    func testLoginWhenDelegateCallsCallback() async {
        mockAuthenticationManager.tokenStub = .token("test-token")
        mockApiClient.responseStub = .value(WykopSecurityRequests.ConnectRequest.Response(connectUrl: "http://test.connect.url"))
        sut.delegate = mockLoginDelegate

        var didFailWithError: Error?

        do {
            try await sut.login()
            mockLoginDelegate.callback?("test-login-token", "test-login-refresh-token")
            try await Task.sleep(nanoseconds: 300_000_000)
            XCTAssertEqual(mockAuthenticationManager.loginToken, "test-login-token", "Should call authentication manager with correct token")
            XCTAssertEqual(mockAuthenticationManager.loginRefreshToken, "test-login-refresh-token", "Should call authentication manager with correct refresh token")
            XCTAssertTrue(mockLoginDelegate.loginCompleted, "Should complete login")
        } catch {
            didFailWithError = error
        }

        XCTAssertNil(didFailWithError, "Should not throw error")
    }

    // MARK: Logout tests
    func testLogout() async {
        var didFailWithError: Error?

        do {
            try await sut.logout()
            XCTAssertTrue(mockAuthenticationManager.logoutCalled, "Should call logout om authentication manager")
        } catch {
            didFailWithError = error
        }

        XCTAssertNil(didFailWithError, "Should not throw error")
    }
}
