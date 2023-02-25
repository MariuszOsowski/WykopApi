//
//  MockTokenDecoder.swift
//  
//
//  Created by Mariusz Osowski on 25/02/2023.
//

import Foundation
@testable import WykopApi

class MockTokenDecoder: TokenDecoding {
    enum MockError: Error {
        case decodingError
    }

    enum StubResult {
        case error(Error)
        case payload(TokenPayload)
    }

    var stubResult: StubResult = .error(MockError.decodingError)
    private(set) var token: String? = nil

    func decodePayload(token: String) throws -> TokenPayload {
        self.token = token

        switch stubResult {
        case .error(let error):
            throw error
        case .payload(let tokenPayload):
            return tokenPayload
        }
    }  
}
