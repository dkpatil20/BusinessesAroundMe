//
//  BusinessesSearchResponse.swift
//  BusinessesAroundMe
//
//  Created by Dhiraj Patil on 26/01/23.
//

import Foundation

// MARK: - Businesses
class BusinessesSearchResponse: Decodable {
    let businesses: [Business]
    let total: Int
}

// MARK: - Business
class Business: Decodable {
    let id, name: String
    let imageURL: String
    let isClosed: Bool
    let url: String
    let reviewCount: Int
    let rating: Double
    let price: String?
    let phone, displayPhone: String
    var photos: [String]?
    var hours: [Hour]?

    private enum CodingKeys: String, CodingKey {
        case id, name
        case imageURL = "image_url"
        case isClosed = "is_closed"
        case url
        case reviewCount = "review_count"
        case rating, price, phone
        case displayPhone = "display_phone"
        case hours, photos
    }
}
