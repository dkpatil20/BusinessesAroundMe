//
//  NetworkWrapper.swift
//  BusinessesAroundMe
//
//  Created by Dhiraj Patil on 26/01/23.
//

import Foundation

class NetworkWrapper {
    
    static func setUpBaseHeader() {
        BaseHeader.baseHeader = [
            "Accept": "application/json",
            "Authorization": "Bearer 3PW75iXnNgFsSrArLrQrtC5SHnilq7lNSVJ4LL-TSFiy19LLZJWh7zFv6F-_W9d9drKzoymoBSMQeVadhbcBA2cWWpfzQQCdmc0OIAEdZ1Pq1fjFFbTVxgK6L-YrY3Yx"
          ]
    }
    static let apiService: APIServicable = APIService()
}
