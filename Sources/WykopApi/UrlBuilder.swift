//
//  UrlBuilder.swift
//  
//
//  Created by Mariusz Osowski on 03/03/2023.
//

import Foundation

protocol UrlBuilding {
    func buildUrl(basePath: String, endpoint: String, queryItems: [URLQueryItem]?) -> URL?
}

class UrlBuilder: UrlBuilding {
    static let shared = UrlBuilder()

    func buildUrl(basePath: String, endpoint: String, queryItems: [URLQueryItem]?) -> URL? {
        guard var components = URLComponents(string: basePath + endpoint) else {
            return nil
        }

        components.queryItems = queryItems
        return components.url
    }
}
