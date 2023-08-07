//
//  SessionApi.swift
//  OnTheMap
//
//  Created by Guido Roos on 07/08/2023.
//

import Foundation

class SessionApi: ApiClient {
    enum Endpoint {
        case session

        var stringValue: String {
            switch self {
            case .session:
                return ApiClient.baseURL + "session"
            }
        }
    }

    class func postSession(
        loginRequest: UdacityLoginRequest
    ) async throws -> UdacityLoginResponse {
        return try await taskForRequest(
            url: getUrl(urlString: Endpoint.session.stringValue),
            requestBody: loginRequest,
            verb: .post,
            shouldCleanData: true
        )
    }

    class func deleteSession() async throws  {
        let url = try getUrl(urlString: Endpoint.session.stringValue)
        var request = URLRequest(url: url)
        request.httpMethod = HTTPVerb.delete.rawValue

        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }

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
                    let cleanedData = data.dropFirst(5)
                    let response = try JSONDecoder().decode(
                        Session.self, from: cleanedData
                    )
                } catch {
                    throw APIError.invalidResponse(description: "unexpected response for request")
                }
            }
        } else {
            throw result.error ?? APIError.unknownError(description: NSLocalizedString("unknown_error", comment: ""))
        }
    }
}
