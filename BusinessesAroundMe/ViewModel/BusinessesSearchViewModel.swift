//
//  BusinessesSearchViewModel.swift
//  BusinessesAroundMe
//
//  Created by Dhiraj Patil on 26/01/23.
//

import Foundation

typealias BusinessesSearchViewModelType = BusinessesSearchViewModelInputType & BusinessesSearchViewModelOutputType & ListViewModelProtocol

protocol BusinessesSearchViewModelInputType {
    func searchBusiness()
}
protocol BusinessesSearchViewModelOutputType {
    var customError: Observable<String?> { get }
}

class BusinessesSearchViewModel: BusinessesSearchViewModelType, Pagination {
    
    var callBefore: IndexPath = IndexPath(row: 3, section: 1)
    
    var sections: Observable<Items>
    
    let limit: Int = 20
    
    var total: Int = -1
    
    var offset: Int
    
    var isAPICalled: APIStatus = .notStarted
    
    var customError: Observable<String?> = Observable(value: nil)
    
    private let loaderSection: DefaultSection
    
    private let services: BusinessesSearchServiceType
    
    
    init(services: BusinessesSearchServiceType) {
        self.services = services
        self.offset = -self.limit
        self.loaderSection = DefaultSection(items: [LoaderTableViewCellViewModel(isLoading: true)])
        self.sections = Observable(value: [loaderSection])
    }
    func callNextPage() {
        searchBusiness()
    }
    
    func searchBusiness() {
        guard shouldCallAPI() else {
            return
        }
        let queryItem = BusinessesSearchRequest(
            latitude: 37.786882,
            longitude: -122.399972,
            sortBy: .bestMatch,
            limit: self.limit,
            offset: self.offset,
            term: "restaurants"
        )
        self.services.searchBusiness(search: queryItem) { [weak self] result in
            if let self = self {
                switch result {
                case .success(let response):
                    self.apiCallFinished(total: response.total)
                    self.createSection(response: response)
                case .failure(let error):
                    self.apiCallFinished(total: nil)
                    Logger.log("appError.errorDescription", error)
                    if let appError = error as? AppError {
                        self.customError.value = appError.errorDescription
                    }
                    // TODO: Need to handle failure state on UI. Skipping it for now
                }
            }
        }
    }
    
    private func createSection(response: BusinessesSearchResponse) {
        var section: SectionViewModelProtocol = DefaultSection()
        if sections.value.count == 2, let firstSection = self[0] {
            section = firstSection
        }
        
        for business in response.businesses {
            section.items.append(BusinessListViewModel(business: business))
        }
        Logger.log(#function,offset, section.items.count)
        var sections: Items =  section.items.isEmpty ? [] : [section]
        if total > offset + limit {
            sections.append(loaderSection)
        }
        self.sections.value = sections
        
        // TODO: Need to handle Empty data on UI. Skipping it for now
        
    }
}

