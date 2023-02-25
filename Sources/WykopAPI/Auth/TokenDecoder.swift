//
//  TokenDecoder.swift
//  
//
//  Created by Mariusz Osowski on 25/02/2023.
//

import Foundation

enum TokenDecoderError: Error, Equatable {
    case invalidToken
    case decodingError
}

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

protocol TokenDecoding {
    func decodePayload(token: String) throws -> TokenPayload
}

class TokenDecoder: TokenDecoding {
    func decodePayload(token: String) throws -> TokenPayload {
        let payload = try getPayload(token: token)
        let base64Decoded = try decodeBase64(base64Encoded: payload)

        do {
            return try JSONDecoder().decode(TokenPayload.self, from: base64Decoded)
        } catch {
            throw TokenDecoderError.decodingError
        }
    }

    private func getPayload(token: String) throws -> String {
        let parts = token.split(separator: ".")
        guard parts.count == 3 else { throw TokenDecoderError.invalidToken }

        return String(parts[1])
    }

    private func decodeBase64(base64Encoded: String) throws -> Data {
        guard let data = base64Encoded.urlSafeBase64Decoded() else {
            throw TokenDecoderError.decodingError
        }

        return data
    }
}
