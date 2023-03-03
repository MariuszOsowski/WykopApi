//
//  WykopTagsApi.swift
//  
//
//  Created by Mariusz Osowski on 02/03/2023.
//

import Foundation

public final class WykopTagsApi: WykopApiCategory {
    public func autocomplete(query: String) async throws -> [WKPTagShort] {
        let authToken = try await authenticationManager.authToken
        return try await apiClient.send(WykopTagRequests.AutocompleteRequest(query: query, authToken: authToken))
    }

    public func popular() async throws -> [WKPTag] {
        let authToken = try await authenticationManager.authToken
        return try await apiClient.send(WykopTagRequests.PopularRequest(authToken: authToken))
    }

    public func details(tagName: String) async throws -> WKPTag {
        let authToken = try await authenticationManager.authToken
        return try await apiClient.send(WykopTagRequests.DetailsRequest(tagName: tagName, authToken: authToken))
    }

    public func popularUserTags() async throws -> [WKPTagShort] {
        let authToken = try await authenticationManager.authToken
        return try await apiClient.send(WykopTagRequests.PopularUserTagsRequest(authToken: authToken))
    }

    public func related(tagName: String) async throws -> [WKPTagShort] {
        let authToken = try await authenticationManager.authToken
        return try await apiClient.send(WykopTagRequests.RelatedRequest(tagName: tagName, authToken: authToken))
    }

    public func authors(tagName: String) async throws -> [WKPUserShort] {
        let authToken = try await authenticationManager.authToken
        return try await apiClient.send(WykopTagRequests.AuthorsRequest(tagName: tagName, authToken: authToken))
    }
}
