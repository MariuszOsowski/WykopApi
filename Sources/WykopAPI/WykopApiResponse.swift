//
//  WykopApiResponse.swift
//  
//
//  Created by Mariusz Osowski on 25/02/2023.
//

import Foundation

internal enum WykopApiResponse<T: Decodable>: Decodable {
    case error(WykopApiErrorResponse)
    case result(T)

    public init(from decoder: Decoder) throws {
        if let errorResponse = try? WykopApiErrorResponse(from: decoder) {
            self = .error(errorResponse)
        } else {
            self = .result(try WykopApiDataResponse<T>(from: decoder).data)
        }
    }
}

internal struct WykopApiErrorResponse: Decodable, Error, LocalizedError {
    let code: Int
    let hash: String
    let error: Error

    internal struct Error: Decodable {
        let message: String
        let key: Int
    }
}

internal struct WykopApiDataResponse<T: Decodable>: Decodable {
    let data: T
}
