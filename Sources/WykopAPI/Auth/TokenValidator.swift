//
//  TokenValidator.swift
//  
//
//  Created by Mariusz Osowski on 25/02/2023.
//

import Foundation

protocol TokenValidating {
    func isExpired(token: TokenPayload) -> Bool
    func isValid(token: String) -> Bool
}

class TokenValidator: TokenValidating {
    let tokenDecoder: TokenDecoding
    
    init(tokenDecoder: TokenDecoding) {
        self.tokenDecoder = tokenDecoder
    }
    
    func isValid(token: String) -> Bool {
        guard let tokenPayload = try? tokenDecoder.decodePayload(token: token) else {
            return false
        }
        
        print("Token username:", tokenPayload.username)
        
        return !isExpired(token: tokenPayload)
    }
    
    func isExpired(token: TokenPayload) -> Bool {
        let calendar = Calendar.current
        let currentDate = Date()
        //86390
        let expirationDate = calendar.date(byAdding: .minute, value: 5, to: currentDate)
        
        if let expirationDate = expirationDate {
            return expirationDate > token.expiryDate
        } else {
            return false
        }
    }
}
