//
//  UserLocationRequest.swift
//  OnTheMap
//
//  Created by Guido Roos on 01/08/2023.
//

import Foundation

struct UserLocationRequest: Codable {
    
    var uniqueKey : String? = nil
    var firstName : String? = nil
    var lastName  : String? = nil
    var mapString : String? = nil
    var mediaURL  : String? = nil
    var latitude  : Double? = nil
    var longitude : Double? = nil
}
