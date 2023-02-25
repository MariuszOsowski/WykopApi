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
        do {
            self = .result(try WykopApiDataResponse<T>(from: decoder).data)
        } catch (error: DecodingError.keyNotFound(_, _)) {
            self = .error(try WykopApiErrorResponse(from: decoder))
        }
    }
}

internal struct WykopApiErrorResponse: Decodable, Error {
    let code: Int64
    let hash: String
    let error: Error
    
    internal struct Error: Decodable {
        let message: String
        let key: Int64
    }
}

internal struct WykopApiDataResponse<T: Decodable>: Decodable {
    let data: T
}
