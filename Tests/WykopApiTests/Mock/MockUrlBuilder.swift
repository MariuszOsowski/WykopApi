//
//  MockUrlBuilder.swift
//  
//
//  Created by Mariusz Osowski on 03/03/2023.
//

import Foundation
@testable import WykopApi

class MockUrlBuilder: UrlBuilding {
    private(set) var capturedBasePath: String?
    private(set) var capturedEndpoint: String?
    private(set) var capturedQueryItems: [URLQueryItem]?

    var stubResult: URL?

    func buildUrl(basePath: String, endpoint: String, queryItems: [URLQueryItem]?) -> URL? {
        capturedBasePath = basePath
        capturedEndpoint = endpoint
        capturedQueryItems = queryItems

        return stubResult
    }
}
