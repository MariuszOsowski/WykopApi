//
//  WykopApiClient.swift
//  
//
//  Created by Mariusz Osowski on 25/02/2023.
//

import Foundation

internal protocol ApiClientProtocol {
    func send<T: WykopApiRequest>(_ request: T) async throws -> T.Response
}

internal final class WykopApiClient: ApiClientProtocol {
    private let session: URLSession
    private let decoder: JSONDecoder

    internal init(session: URLSession = URLSession.shared, decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
    }

    internal func send<T: WykopApiRequest>(_ request: T) async throws -> T.Response {
        let urlRequest = try request.urlRequest()

        do {
            let (data, _) = try await session.data(for: urlRequest)
            let object = try decoder.decode(WykopApiResponse<T.Response>.self, from: data)

            switch object {
            case WykopApiResponse<T.Response>.error(let error):
                throw error
            case WykopApiResponse<T.Response>.result(let response):
                return response
            }
        } catch let error as DecodingError {
            throw WykopApiError.decodingError(error)
        } catch {
            throw WykopApiError.underlaying(error)
        }
    }
}
