//
//  UserLocation.swift
//  OnTheMap
//
//  Created by Guido Roos on 01/08/2023.
//

import Foundation



struct UserLocationResponse: Codable {
    var results: [UserLocation]
}

struct UserLocation: Codable {
    var createdAt: String? = nil
    var firstName: String? = nil
    var lastName: String? = nil
    var latitude: Double? = nil
    var longitude: Double? = nil
    var mapString: String? = nil
    var mediaURL: String? = nil
    var objectId: String? = nil
    var uniqueKey: String? = nil
    var updatedAt: String? = nil
    
    var fullName: String {
        if let firstName = firstName, let lastName = lastName {
            return "\(firstName) \(lastName)"
        } else if let firstName = firstName {
            return firstName
        } else if let lastName = lastName {
            return lastName
        } else {
            return "unknown"
        }
    }
}

class StudentsData: NSObject {
    
    var students = [UserLocation]()
    
    class func sharedInstance() -> StudentsData {
        struct Singleton {
            static var sharedInstance = StudentsData()
        }
        return Singleton.sharedInstance
    }
    
}
