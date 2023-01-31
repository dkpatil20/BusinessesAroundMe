//
//  BusinessDetail.swift
//  BusinessesAroundMe
//
//  Created by Dhiraj Patil on 31/01/23.
//

import Foundation

//class BusinessDetail: Business {
//    let photos: [String]
//    let hours: [Hour]
//    private enum CodingKeys: String, CodingKey {
//        case hours, photos
//    }
//    required init(from decoder: Decoder) throws {
//        
//        // Get our container for this subclass' coding keys
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.hours = try container.decode([Hour].self, forKey: .hours)
//        self.photos = try container.decode([String].self, forKey: .photos)
//
//        let superDecoder = try container.superDecoder()
//        try super.init(from: superDecoder)
//        
//    }
//}
// MARK: - Hour
class Hour: Codable {
    let hourOpen: [OpenHours]
    let hoursType: String
    let isOpenNow: Bool

    enum CodingKeys: String, CodingKey {
        case hourOpen = "open"
        case hoursType = "hours_type"
        case isOpenNow = "is_open_now"
    }
}

// MARK: - Open
class OpenHours: Codable {
    let isOvernight: Bool
    let start, end: String
    let day: Int

    enum CodingKeys: String, CodingKey {
        case isOvernight = "is_overnight"
        case start, end, day
    }
}
