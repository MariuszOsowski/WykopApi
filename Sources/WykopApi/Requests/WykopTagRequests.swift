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

    internal struct PopularRequest: WykopApiRequest {
        typealias Response = [WKPTag]

        var authToken: String
        var method: HTTPMethod = .GET
        var path: String = "/tags/popular"

        var headers: [String: String] {
            return ["Authorization": "Bearer \(authToken)"]
        }
    }

    internal struct DetailsRequest: WykopApiRequest {
        typealias Response = WKPTag

        var tagName: String
        var authToken: String
        var method: HTTPMethod = .GET
        var path: String {
            "/tags/\(tagName)"
        }

        var headers: [String: String] {
            return ["Authorization": "Bearer \(authToken)"]
        }
    }

    internal struct PopularUserTagsRequest: WykopApiRequest {
        typealias Response = [WKPTagShort]

        var authToken: String
        var method: HTTPMethod = .GET
        var path: String = "/tags/popular-user-tags"

        var headers: [String: String] {
            return ["Authorization": "Bearer \(authToken)"]
        }
    }

    internal struct RelatedRequest: WykopApiRequest {
        typealias Response = [WKPTagShort]

        var tagName: String
        var authToken: String
        var method: HTTPMethod = .GET
        var path: String {
            "/tags/\(tagName)/related"
        }

        var headers: [String: String] {
            return ["Authorization": "Bearer \(authToken)"]
        }
    }

    internal struct AuthorsRequest: WykopApiRequest {
        typealias Response = [WKPUserShort]

        var tagName: String
        var authToken: String
        var method: HTTPMethod = .GET
        var path: String {
            "/tags/\(tagName)/users"
        }

        var headers: [String: String] {
            return ["Authorization": "Bearer \(authToken)"]
        }
    }
}
