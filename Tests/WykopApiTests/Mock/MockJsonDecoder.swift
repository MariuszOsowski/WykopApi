//
//  MockJsonDecoder.swift
//  
//
//  Created by Mariusz Osowski on 02/03/2023.
//

import Foundation

class MockJsonDecoder<RT: Decodable>: JSONDecoder {
    enum MockError: Error {
        case invalidResultType
    }

    enum ResultStub {
        case error(Error)
        case success(RT)
    }

    var stubResult: ResultStub?
    var caputuredData: Data?

    override func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable {
        caputuredData = data

        guard let stubResult = stubResult else {
            return try decode(type, from: data)
        }

        switch stubResult {
        case .error(let error):
            throw error
        case .success(let value):
            if let result = value as? T {
                return result
            } else {
                throw MockError.invalidResultType
            }
        }
    }
}
