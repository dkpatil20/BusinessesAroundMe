//
//  BusinessesDetailService.swift
//  BusinessesAroundMe
//
//  Created by Dhiraj Patil on 31/01/23.
//

import Foundation

protocol BusinessesDetailServiceType {
    func searchBusinessBy(id :String, then completionHandler: @escaping ((Result<Business, Error>) -> Void))

}

class BusinessesDetailService: BusinessesDetailServiceType {
    enum EndPoint: Requestable {
        case detail(id: String)
        var endpoint: ApiEndpointType {
            switch self {
            case .detail(id: let id):
                return ApiEndpoint.v3(path: "businesses/\(id)")
            }
        }
        var urlType: URLType {
            return .apiEndpoint(endpoint)
        }
        
        var  requestType: HTTPRequestType {
            switch self {
            case .detail:
                return .get()
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
    
    func searchBusinessBy(id :String, then completionHandler: @escaping ((Result<Business, Error>) -> Void)) {
        let request = EndPoint.detail(id: id)
        self.apiService.getDecodableData(of: Business.self, errorType: CustomError.self, request: request, then: completionHandler)
    }

}
