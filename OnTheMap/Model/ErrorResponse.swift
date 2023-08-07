//
//  ErrorResponse.swift
//  OnTheMap
//
//  Created by Guido Roos on 07/08/2023.
//

import Foundation

struct ErrorResponse: Codable {
    var status: Int
    var error: String
}
