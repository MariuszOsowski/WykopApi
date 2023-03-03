//
//  WKPUserShort.swift
//  
//
//  Created by Mariusz Osowski on 26/02/2023.
//

import Foundation

public struct WKPUserShort: Decodable {
    public let username: String
    public let company: Bool
    public let gender: String?
    public let avatar: URL
    public let note: Bool
    public let online: Bool
    public let status: String
    public let color: String
    public let verified: Bool
    public let follow: Bool
    public let rank: Rank
    public let actions: Actions?

    public struct Rank: Decodable {
        public let position: Int?
        public let trend: Int
    }

    public struct Actions: Decodable {
        public let update: Bool
        public let updateGender: Bool
        public let updateNote: Bool
        public let blacklist: Bool
        public let follow: Bool
    }
}
