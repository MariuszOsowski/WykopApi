//
//  MockBase64Decoder.swift
//  
//
//  Created by Mariusz Osowski on 02/03/2023.
//

import Foundation
@testable import WykopApi

class MockBase64Decoder: Base64Decoding {
    var stubResult: Data?
    private(set) var capturedBase64: String?

    func decode(base64: String) -> Data? {
        capturedBase64 = base64
        return stubResult
    }
}
