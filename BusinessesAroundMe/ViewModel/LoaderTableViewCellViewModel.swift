//
//  LoaderTableViewCellViewModel.swift
//  BusinessesAroundMe
//
//  Created by Dhiraj Patil on 30/01/23.
//

import Foundation
protocol LoaderTableViewCellViewModelType {
    var isLoading: Bool { get }
}
class LoaderTableViewCellViewModel: LoaderTableViewCellViewModelType, ItemViewModelProtocol {
    let isLoading: Bool
    init(isLoading: Bool) {
        self.isLoading = isLoading
    }
}
