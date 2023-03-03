//
//  WykopApiRequestTests.swift
//  
//
//  Created by Mariusz Osowski on 03/03/2023.
//

import Foundation

import XCTest
@testable import WykopApi

struct ApiRequestUnderTests: WykopApiRequest {
    typealias Response = String

    var method: HTTPMethod = .DELETE
    var path: String = "/test-endpoint"
    var queryItems: [URLQueryItem]? = [.init(name: "test_query", value: "test_query_value")]
    var headers: [String: String] = ["test_header": "test_value"]
    var requestBody: Encodable?
    var urlBuilder: UrlBuilding?
}

final class WykopApiRequestTests: XCTestCase {
    func testUrlReqest() throws {
        let headers = [
            "test_header": "test_value",
            "test_header2": "test_value2"
        ]
        let queryItems: [URLQueryItem] = [.init(name: "test_query", value: "test_query_value")]
        let mockUrlBuilder = MockUrlBuilder()

        var sut = ApiRequestUnderTests()
        sut.urlBuilder = mockUrlBuilder
        sut.headers = headers
        sut.queryItems = queryItems
        sut.requestBody = ["test": "value"]

        mockUrlBuilder.stubResult = URL(string: "https://test.url")

        let urlRequest = try sut.urlRequest()

        XCTAssertEqual(urlRequest.url, URL(string: "https://test.url"))
        XCTAssertEqual(mockUrlBuilder.capturedEndpoint, "/test-endpoint")
        XCTAssertEqual(mockUrlBuilder.capturedBasePath, WykopURL.APIv3.rawValue)
        XCTAssertEqual(mockUrlBuilder.capturedQueryItems, queryItems)

        for (header, value) in headers {
            XCTAssertEqual(urlRequest.value(forHTTPHeaderField: header), value)
        }

        XCTAssertEqual(urlRequest.value(forHTTPHeaderField: "Accept"), "application/json")
        XCTAssertEqual(urlRequest.value(forHTTPHeaderField: "Content-Type"), "application/json")
        XCTAssertEqual(urlRequest.httpBody, "{\"test\":\"value\"}".data(using: .utf8))
    }

    func testUrlBuildingError() throws {
        let headers = [
            "test_header": "test_value",
            "test_header2": "test_value2"
        ]
        let queryItems: [URLQueryItem] = [.init(name: "test_query", value: "test_query_value")]
        let mockUrlBuilder = MockUrlBuilder()

        var sut = ApiRequestUnderTests()
        sut.urlBuilder = mockUrlBuilder
        sut.headers = headers
        sut.queryItems = queryItems
        sut.requestBody = ["test": "value"]

        mockUrlBuilder.stubResult = nil

        XCTAssertThrowsError(try sut.urlRequest()) { error in
            XCTAssertEqual(error as? WykopApiError, WykopApiError.invalidUrl)
        }
    }

}
