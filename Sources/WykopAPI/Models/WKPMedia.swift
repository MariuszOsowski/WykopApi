//
//  WKPMedia.swift
//  
//
//  Created by Mariusz Osowski on 26/02/2023.
//

import Foundation

public struct WKPMedia: Decodable {
    public let key: String
    public let label: String
    public let mimeType: String
    public let url: URL
    public let size: Int
    public let width: Int
    public let height: Int
}
