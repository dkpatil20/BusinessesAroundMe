//
//  BusinessesDetailViewModel.swift
//  BusinessesAroundMe
//
//  Created by Dhiraj Patil on 31/01/23.
//

import Foundation

protocol BusinessesDetailViewModelInputType {
    func getDetail()
    func itemClicked(at indexPath: IndexPath)
}
protocol BusinessesDetailViewModelOutputType {
    var name: String { get }
}

typealias BusinessesDetailViewModelType = BusinessesDetailViewModelInputType & BusinessesDetailViewModelOutputType & ListViewModelProtocol

class BusinessesDetailViewModel: BusinessesDetailViewModelType {
  
    
    var name: String
    
    var sections: Observable<Items>
    var customError: Observable<String?> = Observable(value: nil)
    
    private let loaderSection: DefaultSection
    private let services: BusinessesDetailServiceType
    private let businessId: String
    private let currentDayOfWeek: Int
    private let currentTime: String
    init(services: BusinessesDetailServiceType, businessId: String, businessName: String, currentDayOfWeek: Int, currentTime: String = Date().convertToHH_mm()) {
        self.services = services
        self.name = businessName
        self.businessId = businessId
        self.loaderSection = DefaultSection(items: [LoaderTableViewCellViewModel(isLoading: true)])
        self.sections = Observable(value: [loaderSection])
        self.currentDayOfWeek = currentDayOfWeek
        self.currentTime = currentTime
    }
    func getDetail() {
        self.services.searchBusinessBy(id: businessId) { [weak self] result in
            if let self = self {
                switch result {
                case .success(let Business):
                    self.createSections(from: Business)
                case .failure(let error):
                    Logger.log(error)
                    if let appError = error as? AppError {
                        self.customError.value = appError.errorDescription
                    }
                    // TODO: Need to handle failure state on UI. Skipping it for now
       }
            }
        }
    }
    func itemClicked(at indexPath: IndexPath) {
        let section = self.sections.value
        
        let itemSection = section[indexPath.section]
        switch itemSection {
        case let sectionVM as CollapsibleSection:
            if sectionVM.itemFor(row: indexPath.row) is OpenHoursFirstCellViewModel {
                sectionVM.setCollapsibleState()
                self.sections.value = section
            }
        default:
            break
        }
    }
    
    
    private func getPhotoSection(photos: [String]) -> SectionViewModelProtocol {
        var imageCellViewModels = [DefaultSection]()
        for image in photos {
            if let imageURL = URL(string: image) {
                Logger.log(#function,image)
                imageCellViewModels.append(DefaultSection(items: [ImageCellViewModel(imageURL: imageURL)]))
            }
        }
        
        let imageLibCellViewModel = ImageLibCellViewModel(
            sections: imageCellViewModels
        )
        return DefaultSection(items: [imageLibCellViewModel])

    }
    
    private func getOperationalHoursSection(hour: Hour) -> SectionViewModelProtocol {
        
        let headingText: ColoredText
        
        switch hour.isOpenNow {
            
        case true:
            headingText = ColoredText(text: "Open Now", color: .green)
        case false:
            headingText = ColoredText(text: "Closed Now", color: .red)

        }
        
        var collapsibleItem: [ItemViewModelProtocol] = []
        var openHourDict: [Int: String] = [:]
        var subHeading = ""
        for openHour in hour.hourOpen {
            switch openHour.day {
            case currentDayOfWeek - 1:
                if hour.isOpenNow {
                    if openHour.end > currentTime  {
                        subHeading = "Closes at \(openHour.end.convertToHH_colon_mm_a())"
                    }
                } else {
                    if openHour.start > currentTime {
                        subHeading = "Opens at \(openHour.start.convertToHH_colon_mm_a())"
                    }
                }

                break
            case currentDayOfWeek :
                if subHeading.isEmpty, let startDate = openHour.start.dateForHHmm() {
                    subHeading = "Opens at \(startDate.convertToHH_colon_mm_a())"
                }
                break
                
            default:
                break
            }
            
            
            
            openHourDict[openHour.day, default: ""] += "\(openHour.start.convertToHH_colon_mm_a()) - \(openHour.end.convertToHH_colon_mm_a())\n"
        }
        
        let start = currentDayOfWeek - 1
        let end = 5 + currentDayOfWeek
        for index in start...end {
            
            var day = index
            if day > 6 {
                day -= 7
            }
            Logger.log("DAY",day)
            Logger.log("currentDayOfWeek",currentDayOfWeek)
            if let weakday = WeekDay(rawValue: day), let openHours = openHourDict[day] {
                Logger.log(#function, #line, weakday, openHours.trimmingCharacters(in: .whitespacesAndNewlines))
                let openHourViewModel = HeadingSubHeadingCellViewModel(
                    heading: weakday.rawValue.capitalized,
                    subHeading: openHours.trimmingCharacters(in: .whitespacesAndNewlines)
                )
                collapsibleItem.append(openHourViewModel)
            }
        }
        
        Logger.log(#function, #line, hour.isOpenNow, subHeading)
        let mainItem = OpenHoursFirstCellViewModel(headingText: headingText, subHeadingText: subHeading)
        let operationalHourSection = CollapsibleSection(mainItem: mainItem, collapsibleItem: collapsibleItem, isCollapsed: true)

        return operationalHourSection
    }
    
    private func createSections(from businessDetail: Business) {
        
        var operationalHoursArray = [SectionViewModelProtocol]()
        if let hours = businessDetail.hours {
            for hour in hours {
                let operationalHours = getOperationalHoursSection(hour: hour)
                operationalHoursArray.append(operationalHours)
            }
        }
        
        
//        var sections: Items =  [DefaultSection()]
        let otherSection = DefaultSection()
        let phoneItem = HeadingSubHeadingCellViewModel(heading: "Phone", subHeading: businessDetail.displayPhone)
        let reviewItem = HeadingSubHeadingCellViewModel(heading: "Review", subHeading: String(format: "%.1f ★(\(businessDetail.reviewCount))", businessDetail.rating))
        otherSection.items = [phoneItem,reviewItem]

        var sections: Items = []
        if let photos = businessDetail.photos {
            let photosSection = getPhotoSection(photos: photos)
            sections.append(photosSection)
        }
        sections.append(otherSection)
        sections.append(contentsOf: operationalHoursArray)
        self.sections.value = sections
        
    }

}
