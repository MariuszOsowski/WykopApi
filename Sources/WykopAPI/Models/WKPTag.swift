//
//  WKPTag.swift
//  
//
//  Created by Mariusz Osowski on 26/02/2023.
//

import Foundation

public struct WKPTag: Decodable {
    public let createdAt: String
    public let name: String
    public let author: WKPUserShort?
    public let personal: Bool
    public let media: Media
    public let description: String
    public let blacklist: Bool
    public let editable: Bool
    public let followers: Int
    public let follow: Bool
    public let notifications: Bool
    public let actions: Actions

    public struct Media: Decodable {
        public let photo: WKPMedia?
    }

    public struct Actions: Decodable {
        public let delete: Bool
        public let createCoauthor: Bool
        public let deleteCoauthor: Bool
        public let update: Bool
        public let blacklist: Bool
    }
}
