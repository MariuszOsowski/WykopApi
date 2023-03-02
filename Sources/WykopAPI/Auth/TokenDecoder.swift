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

protocol TokenDecoding {
    func decodePayload(token: String) throws -> TokenPayload
}

class TokenDecoder: TokenDecoding {
    let jsonDecoder: JSONDecoder
    let base64Decoder: Base64Decoding
    let tokenSplitter: TokenSplitting

    init(jsonDecoder: JSONDecoder = JSONDecoder.wykopDecoder,
         base64Decoder: Base64Decoding = Base64Decoder(),
         tokenSplitter: TokenSplitting = TokenSplitter()) {
        self.jsonDecoder = jsonDecoder
        self.base64Decoder = base64Decoder
        self.tokenSplitter = tokenSplitter
    }

    func decodePayload(token: String) throws -> TokenPayload {
        guard let payload = tokenSplitter.getPayload(from: token),
              let base64Decoded = base64Decoder.decode(base64: payload) else {
            throw TokenDecoderError.invalidToken
        }

        guard let decodedPayload = try? jsonDecoder.decode(TokenPayload.self, from: base64Decoded) else {
            throw TokenDecoderError.decodingError
        }

        return decodedPayload
    }
}
