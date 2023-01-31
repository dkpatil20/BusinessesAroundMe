//
//  Date+.swift
//  BusinessesAroundMe
//
//  Created by Dhiraj Patil on 31/01/23.
//

import Foundation
extension Date {
    func dayNumberOfWeek() -> Int? {
        return Calendar.current.dateComponents([.weekday], from: self).weekday
    }
    func convertToHH_colon_mm_a() -> String {
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "hh:mm a"
        return dateFormatterPrint.string(from: self)
    }
    func convertToHH_mm() -> String {
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "HHmm"
        return dateFormatterPrint.string(from: self)
    }
}
