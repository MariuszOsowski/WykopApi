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

public class ApiCategory {
    fileprivate let apiClient: ApiClientProtocol
    fileprivate let authenticationManager: AuthenticationProtocol

    fileprivate init(apiClient: ApiClientProtocol, authenticationManager: AuthenticationProtocol) {
        self.apiClient = apiClient
        self.authenticationManager = authenticationManager
    }
}

public final class WykopApi {
    let apiClient: ApiClientProtocol
    let authenticationManager: AuthenticationProtocol

    public let users: Users
    public let tags: Tags
    public weak var delegate: WykopApiLoginDelegate?

    public init(key: String, secret: String) {
        apiClient = WykopApiClient()
        authenticationManager = Authenticator(apiClient: apiClient,
                                              keyStore: Keychain(service: "WypokApp"),
                                              tokenValidator: TokenValidator(tokenDecoder: TokenDecoder()),
                                              tokenDecoder: TokenDecoder(),
                                              secret: secret,
                                              key: key)
        users = Users(apiClient: apiClient, authenticationManager: authenticationManager)
        tags = Tags(apiClient: apiClient, authenticationManager: authenticationManager)
    }

    public final class Users: ApiCategory {}
    public final class Tags: ApiCategory {}
}

extension WykopApi {
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

public extension WykopApi.Tags {
    func autocomplete(query: String) async throws -> [WKPTagAutocomplete] {
        let authToken = try await authenticationManager.authToken
        return try await apiClient.send(WykopTagRequests.AutocompleteRequest(query: query, authToken: authToken))
    }

    func popular() async throws -> [WKPTag] {
        let authToken = try await authenticationManager.authToken
        return try await apiClient.send(WykopTagRequests.PopularRequest(authToken: authToken))
    }

    func details(tagName: String) async throws -> WKPTag {
        let authToken = try await authenticationManager.authToken
        return try await apiClient.send(WykopTagRequests.DetailsRequest(tagName: tagName, authToken: authToken))
    }

    func popularUserTags() async throws -> [WKPTagShort] {
        let authToken = try await authenticationManager.authToken
        return try await apiClient.send(WykopTagRequests.PopularUserTagsRequest(authToken: authToken))
    }

    func related(tagName: String) async throws -> [WKPTagShort] {
        let authToken = try await authenticationManager.authToken
        return try await apiClient.send(WykopTagRequests.RelatedRequest(tagName: tagName, authToken: authToken))
    }

    func authors(tagName: String) async throws -> [WKPUserShort] {
        let authToken = try await authenticationManager.authToken
        return try await apiClient.send(WykopTagRequests.AuthorsRequest(tagName: tagName, authToken: authToken))
    }
}
