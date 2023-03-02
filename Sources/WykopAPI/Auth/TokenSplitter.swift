//
//  TokenSplitter.swift
//  
//
//  Created by Mariusz Osowski on 02/03/2023.
//

import Foundation

protocol TokenSplitting {
    func getPayload(from token: String) -> String?
}

class TokenSplitter: TokenSplitting {
    func getPayload(from token: String) -> String? {
        let parts = token.split(separator: ".")
        guard parts.count == 3 else { return nil }

        return String(parts[1])
    }
}
