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

    internal init(session: URLSession = .shared, decoder: JSONDecoder = .wykopDecoder) {
        self.session = session
        self.decoder = decoder
    }

    internal func send<T: WykopApiRequest>(_ request: T) async throws -> T.Response {
        let urlRequest = try request.urlRequest()
        let (data, response) = try await data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw WykopApiError.badServerResponse
        }

        guard httpResponse.statusCode == 200 else {
            if let errorResponse = try? decoder.decode(WykopApiErrorResponse.self, from: data) {
                throw WykopApiError.wykopError(errorResponse.code, errorResponse.error.message)
            } else {
                throw WykopApiError.statusCode(httpResponse.statusCode)
            }
        }

        do {
            let object = try decoder.decode(WykopApiResponse<T.Response>.self, from: data)

            switch object {
            case WykopApiResponse<T.Response>.error(let error):
                throw error
            case WykopApiResponse<T.Response>.result(let response):
                return response
            }
        } catch let error as DecodingError {
            throw WykopApiError.decodingError(error)
        }
    }

    private func data(for urlRequest: URLRequest) async throws -> (Data, URLResponse) {
        do {
            return try await session.data(for: urlRequest)
        } catch {
            throw WykopApiError.underlaying(error)
        }

    }
}
