//
//  UdacityLoginRequest.swift
//  OnTheMap
//
//  Created by Guido Roos on 01/08/2023.
//

import Foundation

struct UdacityLoginRequest: Codable {
    var udacity : UdacityCredentials? = UdacityCredentials()
}

struct UdacityCredentials: Codable {
    
    var username : String? = nil
    var password : String? = nil
}
