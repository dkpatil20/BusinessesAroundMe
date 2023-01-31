//
//  HTTPMethod.swift
//

import Foundation

public enum HTTPRequestType {
  case get(queryItems: [String: Any]? = nil)
  
  case post(
    queryItems:[String: Any]?  = nil,
    parameters: [String: Any]? = nil
  )
  
  case delete(
    queryItems:[String: Any]?,
    parameters: [String: Any]?
  )
  
  case put(
    queryItems:[String: Any]?,
    parameters: [String: Any]?
  )
  
  case patch(
    queryItems:[String: Any]?,
    parameters: [String: Any]?
  )
}
