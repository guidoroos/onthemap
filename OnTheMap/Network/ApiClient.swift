//
//  ApiClient.swift
//  OnTheMap
//
//  Created by Guido Roos on 06/08/2023.
//

import Foundation

enum APIError: Error {
    case invalidURL(description: String)
    case requestFailed(description: String)
    case emptyData(description: String)
    case invalidData(description: String)
    case invalidRequest(description: String)
    case invalidResponse(description: String)
    case unauthorized(description: String)
    case invalidCredentials(description: String)
    case serverError(description: String)
    case unknownError(description: String)

    var description: String {
        switch self {
        case let .invalidURL(description),
             let .requestFailed(description),
             let .emptyData(description),
             let .invalidData(description),
             let .invalidRequest(description),
             let .invalidResponse(description),
             let .unauthorized(description),
             let .invalidCredentials(description),
             let .serverError(description),
             let .unknownError(description):
            return description
        }
    }
}

enum HTTPVerb: String {
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}

public class ApiClient {
    static var session: Session?
    static var account: UdacityAccount?
    static let baseURL = "https://onthemap-api.udacity.com/v1/"

    static func getUrl(urlString: String) throws -> URL {
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL(description: urlString)
        }
        return url
    }

    static func handleStatusCode(_ statusCode: Int, message: String) -> (success: Bool, error: APIError?) {
        switch statusCode {
        case 200...299:
            return (true, nil)
        case 401:
            return (false, .unauthorized(description: message))
        case 400...499:
            return (false, .invalidRequest(description: message))
        case 500...599:
            return (false, .serverError(description: message))
        default:
            return (false, .unknownError(description: message))
        }
    }

    static func extractErrorMessage(data: Data) -> String {
        let cleanedData = data.dropFirst(5)
        if let json = try? JSONSerialization.jsonObject(with: cleanedData, options: []) as? [String: Any] {
            let errorMessage = json["error"] as? String
            return errorMessage ?? ""
        }
        else {
            return ""
        }
    }

    class func taskForGetRequest<ResponseType: Codable>(
        url: URL,
        shouldCleanData: Bool = false
    ) async throws -> ResponseType {
        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse(description: response.description)
        }
        let result = handleStatusCode(httpResponse.statusCode, message: extractErrorMessage(data: data))

        if result.success {
            if data.isEmpty {
                throw APIError.emptyData(description: NSLocalizedString("no_data_returned", comment: ""))
            } else {
                do {
                    let response:ResponseType
                    
                    if shouldCleanData {
                        let cleanedData = data.dropFirst(5)
                         response = try JSONDecoder().decode(
                            ResponseType.self, from: cleanedData
                        )
                    } else {
                        response = try JSONDecoder().decode(
                            ResponseType.self, from: data
                        )
                    }
                    return response
                } catch {
                    throw APIError.invalidResponse(description: "unexpected response for request")
                }
            }
        } else {
            throw result.error ?? APIError.unknownError(description: NSLocalizedString("unknown_error", comment: ""))
        }
    }

    class func taskForRequest<RequestType: Codable, ResponseType: Codable>(
        url: URL,
        requestBody: RequestType?,
        verb: HTTPVerb,
        shouldCleanData:Bool = false
    ) async throws -> ResponseType {
        var request = URLRequest(url: url)

        if let requestBody = requestBody {
            let json = try JSONEncoder().encode(requestBody)
            request.addValue("application/json", forHTTPHeaderField: "content-type")
            request.httpBody = json
        }

        request.httpMethod = verb.rawValue

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse(description: response.description)
        }
        let result = handleStatusCode(httpResponse.statusCode, message: extractErrorMessage(data: data))

        if result.success {
            if data.isEmpty {
                throw APIError.emptyData(description: NSLocalizedString("no_data_returned", comment: ""))
            } else {
                do {
                    let response:ResponseType
                    
                    if shouldCleanData {
                        let cleanedData = data.dropFirst(5)
                         response = try JSONDecoder().decode(
                            ResponseType.self, from: cleanedData
                        )
                    } else {
                        response = try JSONDecoder().decode(
                            ResponseType.self, from: data
                        )
                    }
                    return response
                } catch {
                    throw APIError.invalidResponse(description: "unexpected response for request")
                }
            }
        } else {
            let error = result.error
            throw result.error ?? APIError.unknownError(description: NSLocalizedString("unknown_error", comment: ""))
        }
    }
}
