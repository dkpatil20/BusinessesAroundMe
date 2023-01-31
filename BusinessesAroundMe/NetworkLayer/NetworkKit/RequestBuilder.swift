//
//  Requestable.swift
//

import Foundation


extension Requestable {
    /// Converts a Request instance to an URLRequest instance.
    public var url: URL? {
        
        switch self.urlType {
        case .apiEndpoint(let endpoint):
            var components = URLComponents(string: endpoint.host)!
            components.path = endpoint.path
            var qryItems: [String: Any]?
            switch self.requestType {
            case .get(queryItems: let queryItems):
                qryItems = queryItems
            case .post(queryItems: let queryItems, parameters: _):
                qryItems = queryItems
            case .delete(queryItems: let queryItems, parameters: _):
                qryItems = queryItems
            case .put(queryItems: let queryItems, parameters: _):
                qryItems = queryItems
            case .patch(queryItems: let queryItems, parameters: _):
                qryItems = queryItems
            }
            let keys = Array(qryItems?.keys.sorted() ?? [])
            var queryItems = [URLQueryItem]()
            for key in keys {
                if let value = qryItems?[key] {
                    queryItems.append(URLQueryItem(name: key, value: "\(value)"))
                }
            }
            if !queryItems.isEmpty{
                components.queryItems = queryItems
            }
            return components.url
            
        case .url(let url):
            return url
        }
        
    }
    
    func createURLRequest() -> (URLRequest, [String: String], [String: Any]?)? {
        // URL object is not nill for empty URL string
        guard let url = self.url, !url.absoluteString.isEmpty else { return nil }
        var urlRequest = URLRequest(url: url,
                                    cachePolicy: self.configuration.cachePolicy)
        urlRequest.timeoutInterval = self.configuration.timeoutInterval
        urlRequest.httpMethod = self.requestType.httpMethod
        
        var request = URLRequest(url: url,
                                 cachePolicy: self.configuration.cachePolicy)
        
        request.timeoutInterval = self.configuration.timeoutInterval
        
        var params: [String: Any]?
        switch self.requestType {
        case .get:
            params = nil
        case .post(_, parameters: let parameters):
            params = parameters
        case .delete(_, parameters: let parameters):
            params = parameters
        case .put(queryItems: _, parameters: let parameters):
            params = parameters
        case .patch(queryItems: _, parameters: let parameters):
            params = parameters
        }
        var newHeader = BaseHeader.baseHeader
        newHeader.merge(self.header ?? [:]) {(current,_) in current}
        return (urlRequest, newHeader, params)
    }
    
    public var urlRequest: URLRequest? {
        let urlRequestHeaderParam = createURLRequest()
        guard var urlRequest = urlRequestHeaderParam?.0 else {
            return nil
        }
        let params: [String: Any]? = urlRequestHeaderParam?.2
        let newHeader = urlRequestHeaderParam?.1 ?? [:]
        for (key,value) in newHeader {
            urlRequest.addValue(value, forHTTPHeaderField: key)
        }
        if let params = params, !params.isEmpty {
            urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        }
        
        return urlRequest
    }
}

