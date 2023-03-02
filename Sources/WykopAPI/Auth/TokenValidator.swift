//
//  TokenValidator.swift
//  
//
//  Created by Mariusz Osowski on 25/02/2023.
//

import Foundation

protocol TokenValidating {
    func isValid(token: String) -> Bool
}

class TokenValidator: TokenValidating {
    let tokenDecoder: TokenDecoding
    let expiryThreshold: TimeInterval

    init(tokenDecoder: TokenDecoding = TokenDecoder(), expiryThreshold: TimeInterval = 300) {
        self.tokenDecoder = tokenDecoder
        self.expiryThreshold = expiryThreshold
    }

    func isValid(token: String) -> Bool {
        guard let tokenPayload = try? tokenDecoder.decodePayload(token: token) else {
            return false
        }

        return !isExpired(token: tokenPayload)
    }

   private  func isExpired(token: TokenPayload) -> Bool {
       let expirationdDateThreshold = Date(timeIntervalSinceNow: expiryThreshold)
       return expirationdDateThreshold > token.expiryDate
    }
}
