//
//  WykopSecurityRequests.swift
//  
//
//  Created by Mariusz Osowski on 25/02/2023.
//

import Foundation

internal struct WykopSecurityRequests {
    struct AuthRequest: WykopApiRequest {
        internal struct Response: Decodable {
            let token: String
        }

        var key: String
        var secret: String
        var method: HTTPMethod = .POST
        var path: String = "/auth"
        var requestBody: Encodable? {
            [
                "data": [
                    "key": self.key,
                    "secret": self.secret
                ]
            ]
        }
    }
}

extension WykopSecurityRequests {
    struct RefreshTokenRequest: WykopApiRequest {
        internal struct Response: Decodable {
            let refreshToken: String
            let token: String
        }

        var refreshToken: String
        var method: HTTPMethod = .POST
        var path: String = "/refresh-token"
        var requestBody: Encodable? {
            [
                "data": [
                    "refresh_token": self.refreshToken
                ]
            ]
        }
    }
}

extension WykopSecurityRequests {
    internal struct ConnectRequest: WykopApiRequest {
        struct Response: Decodable {
            let connectUrl: String
        }

        var authToken: String
        var method: HTTPMethod = .GET
        var path: String = "/connect"
        var headers: [String: String] {
            return ["Authorization": "Bearer \(authToken)"]
        }
    }
}
