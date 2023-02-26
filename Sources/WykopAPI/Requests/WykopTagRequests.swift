//
//  WykopTagRequest.swift
//  
//
//  Created by Mariusz Osowski on 26/02/2023.
//

import Foundation

struct WykopTagRequests {
    internal struct AutocompleteRequest: WykopApiRequest {
        typealias Response = [WKPTagAutocomplete]

        var query: String
        var authToken: String
        var method: HTTPMethod = .GET
        var path: String = "/tags/autocomplete"

        var queryItems: [URLQueryItem]? {
            [.init(name: "query", value: "\(query)")]
        }

        var headers: [String: String] {
            return ["Authorization": "Bearer \(authToken)"]
        }
    }
}
