//
//  WykopApiRequest.swift
//  
//
//  Created by Mariusz Osowski on 25/02/2023.
//

import Foundation

internal protocol WykopApiRequest {
    associatedtype Response: Decodable
    var method: HTTPMethod { get }
    var path: String { get }
    var queryItems: [URLQueryItem]? { get }
    var headers: [String: String] { get }
    var requestBody: Encodable? { get }
    var urlBuilder: UrlBuilding? { get }
    var encoder: JSONEncoder? { get }
    func urlRequest() throws -> URLRequest
}

internal extension WykopApiRequest {
    func urlRequest() throws -> URLRequest {
        guard let url = buildUrl() else {
            throw WykopApiError.invalidUrl
        }

        var request = URLRequest(url: url)
        request.httpMethod = self.method.rawValue

        if let body = requestBody {
            request.httpBody = try encode(body: body)
        }

        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        for (field, value) in headers {
            request.setValue(value, forHTTPHeaderField: field)
        }

        return request
    }

    func data() -> Data? { return nil }
    var requestBody: Encodable? { return nil }
    var queryItems: [URLQueryItem]? { return nil }
    var headers: [String: String] { return [:] }
    var urlBuilder: UrlBuilding? { return UrlBuilder.shared }
    var encoder: JSONEncoder? { return JSONEncoder.wykopEncoder }
}

private extension WykopApiRequest {
    private func buildUrl() -> URL? {
        return urlBuilder?.buildUrl(basePath: WykopURL.APIv3.rawValue,
                                    endpoint: self.path,
                                    queryItems: self.queryItems)
    }

    private func encode(body: Encodable) throws -> Data {
        guard let encoder = encoder else {
            throw WykopApiError.internalError
        }

        do {
            return try encoder.encode(body)
        } catch {
            throw WykopApiError.encodingError(error)
        }
    }
}
