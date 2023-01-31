//
//  OpenHoursCellViewModel.swift
//  BusinessesAroundMe
//
//  Created by Dhiraj Patil on 31/01/23.
//

import Foundation
enum WeekDay: String {
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    case sunday
    
    init?(rawValue: Int) {
        switch rawValue {
        case 0:
            self = .sunday
        case 1:
            self = .monday
        case 2:
            self = .tuesday
        case 3:
            self = .wednesday
        case 4:
            self = .thursday
        case 5:
            self = .friday
        case 6:
            self = .saturday
        default:
            return nil
        }
    }
}

protocol HeadingSubHeadingCellViewModelType {
    var heading: String { get }
    var subHeading: String { get }
}


class HeadingSubHeadingCellViewModel: HeadingSubHeadingCellViewModelType, ItemViewModelProtocol {
    let heading: String
    
    var subHeading: String
    
    init(heading: String, subHeading: String) {
        self.heading = heading
        self.subHeading = subHeading
    }
}
