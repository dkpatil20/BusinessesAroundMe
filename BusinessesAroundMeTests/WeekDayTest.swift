//
//  WeekDayTest.swift
//  BusinessesAroundMeTests
//
//  Created by Dhiraj Patil on 01/02/23.
//

import XCTest
@testable import BusinessesAroundMe
final class WeekDayTest: XCTestCase {

    
    func dayTest(rawValue: Int, expected: WeekDay?) {
        let day = WeekDay(rawValue: rawValue)
        XCTAssertTrue(day == expected, "day\(rawValue) should be \(expected), not \(day)")

    }
    
    func testWeekDayTest() {
        dayTest(rawValue: 0, expected: .sunday)
        dayTest(rawValue: 1, expected: .monday)
        dayTest(rawValue: 2, expected: .tuesday)
        dayTest(rawValue: 3, expected: .wednesday)
        dayTest(rawValue: 4, expected: .thursday)
        dayTest(rawValue: 5, expected: .friday)
        dayTest(rawValue: 6, expected: .saturday)
        dayTest(rawValue: 7, expected: nil)
    }
}
