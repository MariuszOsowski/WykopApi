//
//  AuthenticationManager.swift
//  
//
//  Created by Mariusz Osowski on 25/02/2023.
//

import Foundation

enum AuthenticationState {
    case appAuthenticated
    case userAuthenticated(String)
}

protocol AuthenticationProtocol {
    var state: AuthenticationState { get async throws }
    var authToken: String { get async throws }
    func logout() async throws
    func login(token: String, refreshToken: String) async
}

actor Authenticator: AuthenticationProtocol {
    enum KeychainKey: String {
        case token
        case refreshToken
    }

    enum TokenState {
        case none
        case inProgress(Task<String, Error>)
        case appAuthenticated(String)
        case userAuthenticated(token: String, refreshToken: String)
    }

    private var tokenState: TokenState
    private let apiClient: ApiClientProtocol
    private let keychain: KeychainWrapping
    private let tokenValidator: TokenValidating
    private let tokenDecoder: TokenDecoding

    private let secret: String
    private let key: String

    init(apiClient: ApiClientProtocol,
         keychain: KeychainWrapping,
         tokenValidator: TokenValidating,
         tokenDecoder: TokenDecoding,
         secret: String,
         key: String) {
        self.tokenState = .none
        self.apiClient = apiClient
        self.keychain = keychain
        self.tokenValidator = tokenValidator
        self.tokenDecoder = tokenDecoder
        self.secret = secret
        self.key = key
    }

    var state: AuthenticationState {
        get async throws {
            let token = try await authToken
            let payload = try tokenDecoder.decodePayload(token: token)

            if payload.roles.contains("ROLE_USER") {
                return .userAuthenticated(payload.username)
            } else {
                return .appAuthenticated
            }
        }
    }

    var authToken: String {
        get async throws {
            switch tokenState {
            case .none:
                return try await initializeToken()
            case .inProgress(let task):
                return try await task.value
            case .appAuthenticated(let token) where tokenValidator.isValid(token: token):
                return token
            case .appAuthenticated:
                return try await authenticateApp()
            case .userAuthenticated(let token, _) where tokenValidator.isValid(token: token):
                return token
            case .userAuthenticated(_, let refreshToken):
                return try await refreshUserToken(refreshToken: refreshToken)
            }
        }
    }

    func logout() async throws {
        keychain.delete(key: KeychainKey.token.rawValue)
        keychain.delete(key: KeychainKey.refreshToken.rawValue)

        tokenState = .none
    }

    func login(token: String, refreshToken: String) async {
        keychain.save(string: token, key: KeychainKey.token.rawValue)
        keychain.save(string: refreshToken, key: KeychainKey.refreshToken.rawValue)

        tokenState = .userAuthenticated(token: token, refreshToken: refreshToken)
    }

    func initializeToken() async throws -> String {
        guard let token = keychain.loadString(key: KeychainKey.token.rawValue),
              let refreshToken = keychain.loadString(key: KeychainKey.refreshToken.rawValue) else {
            return try await authenticateApp()
        }

        tokenState = .userAuthenticated(token: token, refreshToken: refreshToken)

        if tokenValidator.isValid(token: token) {
            return token
        } else {
            return try await refreshUserToken(refreshToken: refreshToken)
        }
    }

    func authenticateApp() async throws -> String {
        let fallbackState = tokenState

        let task = Task {
            let token = try await apiClient.send(WykopSecurityRequests.AuthRequest(key: key, secret: secret)).token
            tokenState = .appAuthenticated(token)

            return token
        }

        tokenState = .inProgress(task)

        do {
            return try await task.value
        } catch {
            tokenState = fallbackState
            throw error
        }
    }

    func refreshUserToken(refreshToken: String) async throws -> String {
        let fallbackState = tokenState

        let task = Task {
            let tokens = try await apiClient.send(WykopSecurityRequests.RefreshTokenRequest(refreshToken: refreshToken))
            tokenState = .userAuthenticated(token: tokens.token, refreshToken: tokens.refreshToken)

            keychain.save(string: tokens.token, key: KeychainKey.token.rawValue)
            keychain.save(string: tokens.refreshToken, key: KeychainKey.refreshToken.rawValue)

            return tokens.token
        }

        tokenState = .inProgress(task)

        do {
            return try await task.value
        } catch {
            tokenState = fallbackState
            throw error
        }
    }
}
