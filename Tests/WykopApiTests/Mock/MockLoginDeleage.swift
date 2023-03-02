//
//  MockLoginDelegate.swift
//  
//
//  Created by Mariusz Osowski on 02/03/2023.
//

import Foundation
@testable import WykopApi

class MockLoginDelegate: WykopApiLoginDelegate {
    private(set) var connectUrl: String?
    private(set) var callback: ((String, String) -> Void)?
    private(set) var loginCompleted: Bool = false

    func wykopConnect(connectUrl: String, callback: @escaping (String, String) -> Void) {
        self.connectUrl = connectUrl
        self.callback = callback
    }

    func loginComplete() {
        loginCompleted = true
    }
}
