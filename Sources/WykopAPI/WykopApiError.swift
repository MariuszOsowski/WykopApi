//
//  WykopApiError.swift
//  
//
//  Created by Mariusz Osowski on 25/02/2023.
//

import Foundation

public enum WykopApiError: Error {
    case underlaying(Error, URLResponse?)
    case invalidUrl
    case noData
    case encodingError(Error)
    case decodingError(Error)
}
