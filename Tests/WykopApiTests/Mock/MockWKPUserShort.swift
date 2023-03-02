//
//  MockWKPUserShort.swift
//  
//
//  Created by Mariusz Osowski on 02/03/2023.
//

import Foundation
@testable import WykopApi

extension WKPUserShort: Equatable {
    public static func == (lhs: WKPUserShort, rhs: WKPUserShort) -> Bool {
        return lhs.username == rhs.username
    }

    static let mock = WKPUserShort(username: "test-name",
                                   company: false,
                                   gender: "test-gender",
                                   avatar: URL(string: "www.google.com")!,
                                   note: false,
                                   online: false,
                                   status: "test-status",
                                   color: "green",
                                   verified: true,
                                   follow: false, rank: Rank(position: nil, trend: 0),
                                   actions: nil)
}
