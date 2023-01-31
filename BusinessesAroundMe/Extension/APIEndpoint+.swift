//
//  APIEndpoint+.swift
//  BusinessesAroundMe
//
//  Created by Dhiraj Patil on 26/01/23.
//

import Foundation
enum APIBaseURL: String {
    case host = "https://api.yelp.com"
}
extension ApiEndpoint {
    static func v3(path: String) -> ApiEndpoint {
        ApiEndpoint(host: APIBaseURL.host.rawValue, path: "/v3/"+path)
    }
}
