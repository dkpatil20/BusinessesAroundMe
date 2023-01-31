//
//  BusinessesSearchRequest.swift
//  BusinessesAroundMe
//
//  Created by Dhiraj Patil on 26/01/23.
//

import Foundation
enum SortBy:String, Encodable {
    case bestMatch = "best_match"
    case rating
    case reviewCount = "review_count"
    case distance
}
struct BusinessesSearchRequest: Encodable {
    let latitude: Double
    let longitude: Double
    let sortBy: SortBy
    let limit: Int
    let offset: Int
    let term: String
    enum CodingKeys: String, CodingKey {
        case latitude, longitude, limit, offset, term
        case sortBy = "sort_by"
    }
}
