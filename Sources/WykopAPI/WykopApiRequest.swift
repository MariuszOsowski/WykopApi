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
    
    func data() -> Data? {
        return nil
    }
    
    var requestBody: Encodable? {
        return nil
    }
    
    var queryItems: [URLQueryItem]? {
        return nil
    }
    
    var headers: [String: String] {
        return [:]
    }
}

private extension WykopApiRequest {
    private func buildUrl() -> URL? {
        guard var components = URLComponents(string: WykopURL.APIv3.rawValue + self.path) else {
            return nil
        }
        
        components.queryItems = queryItems
        return components.url
    }
    
    private func encode(body: Encodable) throws -> Data {
        do {
            return try JSONEncoder().encode(body)
        } catch {
            throw WykopApiError.encodingError(error)
        }
    }
    
}
