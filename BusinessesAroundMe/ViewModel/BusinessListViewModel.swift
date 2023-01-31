//
//  BusinessListViewModel.swift
//  BusinessesAroundMe
//
//  Created by Dhiraj Patil on 26/01/23.
//

import Foundation

protocol BusinessListViewModelType {
    var id: String { get }
    var name: String { get }
    var price: String { get }
    var imageURL: URL? { get }
    var rating: String { get }

}

class BusinessListViewModel: BusinessListViewModelType, ItemViewModelProtocol {
    let id: String
    let name: String
    let price: String
    let imageURL: URL?
    let rating: String

    init(id: String, name: String, price: String, imageURL: URL?, rating: String) {
        self.id = id
        self.name = name
        self.imageURL = imageURL
        self.price = price
        self.rating = rating

    }
    convenience init(business: Business) {
        let price =
        "Price: \(business.price ?? "-")"
        
        self.init(
            id: business.id,
            name: business.name,
            price: price,
            imageURL: URL(string: business.imageURL),
            rating: String(format: "%.1f ★", business.rating)
        )
    }
}
