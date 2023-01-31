//
//  OpenHoursFirstCellViewModel.swift
//  BusinessesAroundMe
//
//  Created by Dhiraj Patil on 31/01/23.
//

import Foundation

struct ColoredText {
    var text: String
    var color: AppColors
}
enum ArrowIcon: String {
    case up = "chevron.up"
    case down = "chevron.down"
}

class OpenHoursFirstCellViewModel: ItemViewModelProtocol & CollapsibleItem {
    
    let headingText: ColoredText
    let subHeadingText: String
    var arrowIcon: ArrowIcon
    
    init(headingText: ColoredText, subHeadingText: String, arrowIcon: ArrowIcon = .down) {
        self.headingText = headingText
        self.subHeadingText = subHeadingText
        self.arrowIcon = arrowIcon
    }
    func setCollapsibleState(isCollapsed: Bool) {
        self.arrowIcon = isCollapsed ? .down : .up
    }
    
}
