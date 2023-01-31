//
//  String+.swift
//  BusinessesAroundMe
//
//  Created by Dhiraj Patil on 31/01/23.
//

import Foundation
extension String {
    
    func dateForHHmm() -> Date? {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "HHmm"
        return dateFormatterGet.date(from: self)
    }
    
    func convertToHH_colon_mm_a() -> String {
        return dateForHHmm()?.convertToHH_colon_mm_a() ?? ""
    }
}
