//
//  WykopUsersApi.swift
//  
//
//  Created by Mariusz Osowski on 02/03/2023.
//

import Foundation

public final class WykopUsersApi: WykopApiCategory {
    public func autocomplete(query: String) async throws -> [WKPUserAutocomplete] {
        let authToken = try await authenticationManager.authToken
        return try await apiClient.send(WykopUsersRequests.AutocompleteRequest(query: query, authToken: authToken))
    }
}
