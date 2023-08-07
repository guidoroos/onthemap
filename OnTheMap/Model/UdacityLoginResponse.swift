//
//  UdacityLoginResponse.swift
//  OnTheMap
//
//  Created by Guido Roos on 01/08/2023.
//

import Foundation

struct UdacityLoginResponse: Codable {
    var account: UdacityAccount? = UdacityAccount()
    var session: Session? = Session()
}

struct UdacityAccount: Codable {
    var registered: Bool? = nil
    var key: String? = nil
}


