//
//  WykopUsersRequests.swift
//
//
//  Created by Mariusz Osowski on 25/02/2023.
//

import Foundation

internal struct WykopUsersRequests {
    internal struct AutocompleteRequest: WykopApiRequest {
        typealias Response = [WKPUserAutocomplete]

        var query: String
        var authToken: String
        var method: HTTPMethod = .GET
        var path: String = "/users/autocomplete"

        var queryItems: [URLQueryItem]? {
            [.init(name: "query", value: "\(query)")]
        }

        var headers: [String: String] {
            return ["Authorization": "Bearer \(authToken)"]
        }
    }
}
