//
//  WykopRequestBody.swift
//  
//
//  Created by Mariusz Osowski on 25/02/2023.
//

import Foundation

struct WykopRequestBody<T: Encodable>: Encodable {
    let data: T
}
