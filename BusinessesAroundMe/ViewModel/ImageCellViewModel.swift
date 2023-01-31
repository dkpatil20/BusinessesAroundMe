//
//  ImageCellViewModel.swift
//  BusinessesAroundMe
//
//  Created by Dhiraj Patil on 31/01/23.
//

import Foundation
protocol ImageCellViewModelType {
    var imageURL: URL { get }
}
class ImageCellViewModel: ImageCellViewModelType, ItemViewModelProtocol {
    var imageURL: URL
    init(imageURL: URL) {
        self.imageURL = imageURL
    }
}
