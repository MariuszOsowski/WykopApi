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

    internal init() {
        session = URLSession.shared
    }

    internal func send<T: WykopApiRequest>(_ request: T) async throws -> T.Response {
        let urlRequest = try request.urlRequest()

        return try await withCheckedThrowingContinuation { continuation in
            URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                guard let responseData = data, error == nil else {
                    if let error = error {
                        continuation.resume(throwing: WykopApiError.underlaying(error, response))
                    } else {
                        continuation.resume(throwing: WykopApiError.noData)
                    }
                    return
                }

                let decoder = JSONDecoder()

                do {
                    let object = try decoder.decode(WykopApiResponse<T.Response>.self, from: responseData)

                    switch object {
                    case WykopApiResponse<T.Response>.error(let error):
                        continuation.resume(throwing: error)
                    case WykopApiResponse<T.Response>.result(let response):
                        continuation.resume(returning: response)
                    }
                } catch {
                    continuation.resume(throwing: WykopApiError.decodingError(error))
                }
            }.resume()
        }
    }
}
