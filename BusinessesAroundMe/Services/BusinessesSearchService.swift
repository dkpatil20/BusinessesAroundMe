//
//  BusinessesSearchService.swift
//  BusinessesAroundMe
//
//  Created by Dhiraj Patil on 26/01/23.
//

import Foundation

protocol BusinessesSearchServiceType {
    func searchBusiness(search :BusinessesSearchRequest, then completionHandler: @escaping ((Result<BusinessesSearchResponse, Error>) -> Void))
}



class BusinessesSearchService: BusinessesSearchServiceType {
    enum EndPoint: Requestable {
        case search(queryItem: BusinessesSearchRequest)
        
        var endpoint: ApiEndpointType {
            return ApiEndpoint.v3(path: "businesses/search")
        }
        var urlType: URLType {
            return .apiEndpoint(endpoint)
        }
        
        var  requestType: HTTPRequestType {
            switch self {
            case .search(queryItem: let queryItem):
                return .get(queryItems: queryItem.toDictionary())
            }
        }
        
        var header: [String : String]? {
            return nil
        }
    }
    let apiService: APIServicable
    init(apiService: APIServicable = NetworkWrapper.apiService) {
        self.apiService = apiService
    }
    
    func searchBusiness(search :BusinessesSearchRequest, then completionHandler: @escaping ((Result<BusinessesSearchResponse, Error>) -> Void)) {
        let request = EndPoint.search(queryItem: search)
        self.apiService.getDecodableData(of: BusinessesSearchResponse.self, errorType: CustomError.self, request: request, then: completionHandler)
    }
}
