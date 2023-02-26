//
//  JSONDecoder+Wykop.swift
//  
//
//  Created by Mariusz Osowski on 26/02/2023.
//

import Foundation

extension JSONDecoder {
    static let wykopDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        return decoder
    }()
}
