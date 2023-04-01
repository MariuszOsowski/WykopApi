//
//  MockJsonEncoder.swift
//  
//
//  Created by Mariusz Osowski on 04/03/2023.
//

import Foundation

class MockJsonEncoder: JSONEncoder {
    enum MockError: Error {
        case invalidResultType
    }

    enum ResultStub {
        case error(Error)
        case success(Data)
    }

    var stubResult: ResultStub?
    private(set) var capturedValue: (any Encodable)?

    override func encode<T>(_ value: T) throws -> Data where T: Encodable {
        capturedValue = value

        guard let stubResult = stubResult else {
            return try encode(value)
        }

        switch stubResult {
        case .error(let error):
            throw error
        case .success(let data):
            return data
        }
    }
}
