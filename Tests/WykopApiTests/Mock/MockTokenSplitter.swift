//
//  MockTokenSplitter.swift
//  
//
//  Created by Mariusz Osowski on 02/03/2023.
//

import Foundation
@testable import WykopApi

class MockTokenSplitter: TokenSplitting {
    var stubResult: String?
    private(set) var capturedToken: String?

    func getPayload(from token: String) -> String? {
        capturedToken = token
        return stubResult
    }
}
