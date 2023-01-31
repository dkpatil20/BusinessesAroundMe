//
//  ApiEndpointType.swift
//

import Foundation

public protocol ApiEndpointType {
    var host: String { get }
    var path: String { get }
}
public enum URLType {
    case url(URL)
    case apiEndpoint(ApiEndpointType)
}

public struct ApiEndpoint: ApiEndpointType {
  public let host: String
  public let path: String
  
  public init(host: String, path: String) {
    self.host = host
    self.path = path
  }
  
}
