//
//  Base64Decoder.swift
//  
//
//  Created by Mariusz Osowski on 02/03/2023.
//

import Foundation

protocol Base64Decoding {
    func decode(base64: String) -> Data?
}

class Base64Decoder: Base64Decoding {
    func decode(base64: String) -> Data? {
        var base64 = base64
        base64 = base64
            .replacingOccurrences(of: "_", with: "/")
            .replacingOccurrences(of: "-", with: "+")

        let remainder = base64.count % 4

        if remainder > 0 {
            base64 = base64.padding(toLength: base64.count + 4 - remainder,
                              withPad: "=",
                              startingAt: 0)
        }

        return Data(base64Encoded: base64, options: .ignoreUnknownCharacters)
    }
}
