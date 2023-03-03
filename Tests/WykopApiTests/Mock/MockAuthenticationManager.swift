//
//  MockAuthenticationManager.swift
//  
//
//  Created by Mariusz Osowski on 02/03/2023.
//

import Foundation
@testable import WykopApi

class MockAuthenticationManager: AuthenticationProtocol {
    enum AuthenticationStateStub {
        case state(AuthenticationState)
        case error(Error)
    }

    enum TokenStub {
        case token(String)
        case error(Error)
    }

    var stateStub: AuthenticationStateStub = .error(NSError(domain: "mock.authentication.manager", code: 0))
    var tokenStub: TokenStub = .error(NSError(domain: "mock.authentication.manager", code: 0))
    var authTokenCallCounter = 0
    private(set) var logoutCalled = false
    private(set) var loginToken: String?
    private(set) var loginRefreshToken: String?
    var logoutError: Error?
    var loginError: Error?

    var state: AuthenticationState {
        get throws {
            switch stateStub {
            case .state(let authenticationState):
                return authenticationState
            case .error(let error):
                throw error
            }
        }
    }

    var authToken: String {
        get throws {
            authTokenCallCounter += 1
            switch tokenStub {
            case .token(let token):
                return token
            case .error(let error):
                throw error
            }
        }
    }

    func logout() async {
        logoutCalled = true
    }

    func login(token: String, refreshToken: String) async {
        loginToken = token
        loginRefreshToken = refreshToken
    }
}
