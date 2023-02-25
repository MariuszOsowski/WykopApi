//
//  WykopApi.swift
//
//
//  Created by Mariusz Osowski on 25/02/2023.
//


import Foundation

public protocol WykopApiLoginDelegate: AnyObject {
    func wykopConnect(connectUrl: String, callback: @escaping (_ token: String, _ refreshToken: String) -> Void)
    func loginComplete()
}

public final class WykopApi {
    let apiClient: ApiClientProtocol
    let authenticationManager: AuthenticationProtocol
    public let users: Users
    public weak var delegate: WykopApiLoginDelegate?
    
    public init(key: String, secret: String) {
        apiClient = WykopApiClient()
        authenticationManager = Authenticator(apiClient: apiClient, keychain: KeychainWrapper(service: "WypokApp"), tokenValidator: TokenValidator(tokenDecoder: TokenDecoder()), tokenDecoder: TokenDecoder(), secret: secret, key: key)
        users = Users(apiClient: apiClient, authenticationManager: authenticationManager)
    }

    public final class Users {
        private let apiClient: ApiClientProtocol
        private let authenticationManager: AuthenticationProtocol

        fileprivate init(apiClient: ApiClientProtocol, authenticationManager: AuthenticationProtocol) {
            self.apiClient = apiClient
            self.authenticationManager = authenticationManager
        }
    }

    public func logout() async throws {
        try await authenticationManager.logout()
    }
    
    public func login() async throws {
        guard let delegate = delegate else { return }
        
        let authToken = try await authenticationManager.authToken
        let connectUrl = try await apiClient.send(WykopSecurityRequests.ConnectRequest(authToken: authToken)).connectUrl
        delegate.wykopConnect(connectUrl: connectUrl, callback: login(token:refreshToken:))
    }
    
    private func login(token: String, refreshToken: String) {
        Task {
            await authenticationManager.login(token: token, refreshToken: refreshToken)
            delegate?.loginComplete()
        }
    }
}

public extension WykopApi.Users {
    func autocomplete(query: String) async throws -> [WKPUserAutocomplete] {
        let authToken = try await authenticationManager.authToken
        return try await apiClient.send(WykopUsersRequests.AutocompleteRequest(query: query, authToken: authToken))
    }
}

