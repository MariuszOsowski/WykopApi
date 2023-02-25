//
//  String+Base64.swift
//  
//
//  Created by Mariusz Osowski on 25/02/2023.
//

import Foundation

extension String {
    func urlSafeBase64Decoded() -> Data? {
        var str = self
            .replacingOccurrences(of: "_", with: "/")
            .replacingOccurrences(of: "-", with: "+")
        
        let remainder = self.count % 4
        
        if remainder > 0 {
            str = str.padding(toLength: self.count + 4 - remainder,
                              withPad: "=",
                              startingAt: 0)
        }
        
        return Data(base64Encoded: str, options: .ignoreUnknownCharacters)
    }
}
