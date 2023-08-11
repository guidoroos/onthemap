//
//  UserDataResponse.swift
//  OnTheMap
//
//  Created by Guido Roos on 01/08/2023.
//

import Foundation

struct User: Codable {
    let firstName: String
    let lastName: String
    let nickname: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case nickname
    }
}
   
