//
//  MockApiClient.swift
//  
//
//  Created by Mariusz Osowski on 02/03/2023.
//

import Foundation
@testable import WykopApi

class MockApiClient: ApiClient {
    enum MockError: Error {
        case invalidResponseType
    }

    enum ResponseStub {
        case value(Decodable)
        case error(Error)
    }

    private(set) var capturedRequest: (any WykopApiRequest)?
    var responseStub: ResponseStub = .error(NSError(domain: "mock.api.client", code: 0))

    func send<T>(_ request: T) async throws -> T.Response where T : WykopApiRequest {
        capturedRequest = request

        switch responseStub {
        case .value(let response):
            guard let response = response as? T.Response else {
                throw MockError.invalidResponseType
            }
            return response
        case .error(let error):
            throw error
        }
    }
}
