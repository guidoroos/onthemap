//
//  LocationApi.swift
//  OnTheMap
//
//  Created by Guido Roos on 06/08/2023.
//

import Foundation

class LocationApi: ApiClient {
    
    enum Endpoint {
        case getUserData(ID:String)
        case studentLocation
        case putStudentLocation (ID: String)
        case filteredStudentLocation(limit: Int?, skip: Int?, order: String?, uniqueKey: String?)

        var stringValue: String {
            switch self {
            case let .getUserData(ID):
                return ApiClient.baseURL + "/users/" + ID
                
            case .studentLocation:
                return ApiClient.baseURL + "StudentLocation"
            case let .putStudentLocation(ID):
                return ApiClient.baseURL + "StudentLocation/" + ID

            case let .filteredStudentLocation(
                limit,
                skip,
                order,
                uniqueKey
            ):
                var queryItems = [URLQueryItem]()
                if let limit = limit {
                    queryItems.append(URLQueryItem(name: "limit", value: "\(limit)"))
                }
                if let skip = skip {
                    queryItems.append(URLQueryItem(name: "skip", value: "\(skip)"))
                }
                if let order = order {
                    queryItems.append(URLQueryItem(name: "order", value: order))
                }
                if let uniqueKey = uniqueKey {
                    queryItems.append(URLQueryItem(name: "uniqueKey", value: uniqueKey))
                }

                var urlComponents = URLComponents(string: ApiClient.baseURL + "StudentLocation")
                urlComponents?.queryItems = queryItems
                return urlComponents?.url?.absoluteString ?? ApiClient.baseURL + "StudentLocation"
            }
        }
    }

    class func getUserLocations() async throws -> UserLocationResponse {
        return try await taskForGetRequest(url: getUrl(urlString: Endpoint.studentLocation.stringValue)
        )
    }

    class func getFilteredUserLocations(
        limit: Int? = nil,
        skip: Int? = nil,
        order: String? = nil,
        uniqueKey: String? = nil
    ) async throws -> UserLocationResponse {
        return try await taskForGetRequest(url: getUrl(urlString: Endpoint.filteredStudentLocation(
            limit: limit,
            skip: skip,
            order: order,
            uniqueKey: uniqueKey
        ).stringValue))
    }

    class func postUserLocation(
        userLocation: UserLocationRequest
    ) async throws -> PostUserLocationResponse {
        return try await taskForRequest(
            url: getUrl(urlString: Endpoint.studentLocation.stringValue),
            requestBody: userLocation,
            verb: .post
        )
    }
    
    class func putUserLocation(
        userLocation: UserLocationRequest
    ) async throws -> PutUserLocationResponse {
        guard let ID = userLocation.uniqueKey else {
            throw APIError.invalidRequest(description: NSLocalizedString("userlocation_not_exist", comment: ""))
        }
        
        return try await taskForRequest(
            url: getUrl(urlString: Endpoint.putStudentLocation(ID: ID).stringValue),
            requestBody: userLocation,
            verb: .put
        )
    }
    
    class func getUserData(ID: String) async throws -> UserDataResponse {
        return try await taskForGetRequest(url: getUrl(urlString: Endpoint.getUserData(ID: ID).stringValue)
        )
    }

}
