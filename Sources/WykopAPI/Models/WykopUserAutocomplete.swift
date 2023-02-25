//
//  WKPUserAutocomplete.swift
//  
//
//  Created by Mariusz Osowski on 25/02/2023.
//

import Foundation

public struct WKPUserAutocomplete: Decodable {
    public let username: String
    public let gender: String?
    public let color: String
    public let avatar: String
}
