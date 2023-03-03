//
//  WykopApiError.swift
//  
//
//  Created by Mariusz Osowski on 25/02/2023.
//

import Foundation

public enum WykopApiError: Error {
    case underlaying(Error)
    case invalidUrl
    case encodingError(Error)
    case decodingError(Error)
    case internalError
    case badServerResponse
    case statusCode(Int)
    case wykopError(Int, String)
}

extension WykopApiError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .underlaying(let error):
            return "Underlaying Error: \(error.localizedDescription)"
        case .invalidUrl:
            return "Invalid URL"
        case .encodingError(let error):
            return "Encoding Error: \(error.localizedDescription)"
        case .decodingError(let error):
            return "Decoding Error: \(error.localizedDescription)"
        case .internalError:
            return "Internal Error"
        case .badServerResponse:
            return "Bad Server Response"
        case .statusCode(let code):
            return "Invalid Status Code: \(code)"
        case .wykopError(let code, let message):
            return "Wykop Error \(code): \(message)"
        }
    }
}

extension WykopApiError: Equatable {
    public static func == (lhs: WykopApiError, rhs: WykopApiError) -> Bool {
        return lhs.localizedDescription == rhs.localizedDescription
    }
}
