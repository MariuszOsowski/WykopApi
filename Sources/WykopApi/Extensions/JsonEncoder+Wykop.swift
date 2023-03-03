//
//  JsonEncoder+Wykop.swift
//  
//
//  Created by Mariusz Osowski on 03/03/2023.
//

import Foundation

extension JSONEncoder {
    static let wykopEncoder: JSONEncoder = {
        let decoder = JSONEncoder()
        decoder.keyEncodingStrategy = .convertToSnakeCase

        return decoder
    }()
}
