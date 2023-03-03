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
    let apiClient: ApiClient
    let authenticationManager: AuthenticationProtocol

    public let users: WykopUsersApi
    public let tags: WykopTagsApi
    public weak var delegate: WykopApiLoginDelegate?

    public convenience init(key: String, secret: String) {
        let apiClient = WykopApiClient()
        let authenticationManager = Authenticator(apiClient: apiClient,
                                              keyStore: Keychain(service: "WypokApp"),
                                              tokenValidator: TokenValidator(),
                                              tokenDecoder: TokenDecoder(),
                                              secret: secret,
                                              key: key)

        self.init(apiClient: apiClient, authenticationManager: authenticationManager)
    }

    init(apiClient: ApiClient, authenticationManager: AuthenticationProtocol) {
        self.apiClient = apiClient
        self.authenticationManager = authenticationManager

        users = WykopUsersApi(apiClient: apiClient, authenticationManager: authenticationManager)
        tags = WykopTagsApi(apiClient: apiClient, authenticationManager: authenticationManager)
    }
}

extension WykopApi {
    public func logout() async throws {
        await authenticationManager.logout()
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
