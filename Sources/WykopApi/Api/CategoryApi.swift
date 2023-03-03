//
//  CategoryApi.swift
//  
//
//  Created by Mariusz Osowski on 02/03/2023.
//

import Foundation

public class WykopApiCategory {
    internal let apiClient: ApiClient
    internal let authenticationManager: AuthenticationProtocol

    internal init(apiClient: ApiClient, authenticationManager: AuthenticationProtocol) {
        self.apiClient = apiClient
        self.authenticationManager = authenticationManager
    }
}
