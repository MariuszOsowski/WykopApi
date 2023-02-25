//
//  WykopSecurityRequests.swift
//  
//
//  Created by Mariusz Osowski on 25/02/2023.
//

import Foundation

internal struct WykopSecurityRequests {
    struct AuthRequest: WykopApiRequest {
        var key: String
        var secret: String
        
        var method: HTTPMethod = .POST
        var path: String = "/auth"
        
        internal struct Response: Decodable {
            let token: String
        }
        
        var requestBody: Encodable? {
            [
                "data" : [
                    "key": self.key,
                    "secret": self.secret
                ]
            ]
        }
    }
}

extension WykopSecurityRequests {
    struct RefreshTokenRequest: WykopApiRequest {
        var refreshToken: String
        
        var method: HTTPMethod = .POST
        var path: String = "/refresh-token"
        
        internal struct Response: Decodable {
            let refreshToken: String
            let token: String
            
            enum CodingKeys: String, CodingKey {
                case refreshToken = "refresh_token"
                case token
            }
        }
        
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
        var authToken: String
        
        var method: HTTPMethod = .GET
        var path: String = "/connect"
        
        struct Response: Decodable {
            let connectUrl: String
            
            enum CodingKeys: String, CodingKey {
                case connectUrl = "connect_url"
            }
        }
        
        var headers: [String : String] {
            return ["Authorization": "Bearer \(authToken)"]
        }
    }
}
