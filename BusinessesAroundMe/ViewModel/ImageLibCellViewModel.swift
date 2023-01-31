//
//  ImageLibCellViewModel.swift
//  BusinessesAroundMe
//
//  Created by Dhiraj Patil on 31/01/23.
//

import Foundation
class ImageLibCellViewModel: ItemViewModelProtocol, ListViewModelProtocol {
    var sections: Observable<Items>
    init(sections: Items) {
        self.sections = Observable(value: sections)
    }
    
}
