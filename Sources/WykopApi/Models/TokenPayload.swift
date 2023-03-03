//
//  TokenPayload.swift
//  
//
//  Created by Mariusz Osowski on 02/03/2023.
//

import Foundation

struct TokenPayload: Decodable {
    let username: String
    let expiryDate: Date
    let roles: [String]

    enum CodingKeys: String, CodingKey {
        case username
        case roles
        case expiryDate = "exp"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.username = try container.decode(String.self, forKey: .username)
        self.roles = try container.decode([String].self, forKey: .roles)
        let timestamp = try container.decode(TimeInterval.self, forKey: .expiryDate)
        self.expiryDate = Date(timeIntervalSince1970: timestamp)
    }

    init(username: String, expiryDate: Date, roles: [String]) {
        self.username = username
        self.expiryDate = expiryDate
        self.roles = roles
    }
}
