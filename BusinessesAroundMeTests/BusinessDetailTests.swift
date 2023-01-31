//
//  BusinessDetailTests.swift
//  BusinessesAroundMeTests
//
//  Created by Dhiraj Patil on 31/01/23.
//

import XCTest
@testable import BusinessesAroundMe

final class BusinessDetailTests: XCTestCase, TestLoaderSection, CustomErrorTest {

    let businessId = "PsY5DMHxa5iNX_nX0T-qPA"
    let businessName = "Sotto Mare"
    lazy var networkSession = MockNetworkSession()
    lazy var service: BusinessesDetailServiceType = BusinessesDetailService(
        apiService: APIService(
            networkSession: networkSession
        )
    )
    
    lazy var viewModel =
        BusinessesDetailViewModel(services: service, businessId: businessId, businessName: businessName,currentDayOfWeek: 3, currentTime: "1300")


}

extension BusinessDetailTests {
    
    fileprivate func assertPhotoSection(_ viewModel: ListViewModelProtocol, expected: [String]) {
        let photoLibSection = viewModel.sectionAt(index: 0)
        XCTAssertTrue(photoLibSection != nil, "photoSection should not be nil")
        XCTAssertTrue(photoLibSection?.numberOfRowIn() == 1, "photoSection should have 1 row")
        
        let imageLibSection = photoLibSection?.itemFor(row: 0) as? ImageLibCellViewModel
        XCTAssertTrue(imageLibSection != nil, "imageLibSection should not be nil")
        guard let imageLibSection = imageLibSection else {
            return
        }
        XCTAssertTrue(imageLibSection.numberOfSection() == 3, "imageLibSection should have 3 numberOfSection, not \(imageLibSection.numberOfSection())")
        
//        let firstImageLibSection = imageLibSection.sectionAt(index: 0)
//        XCTAssertTrue(firstImageLibSection != nil, "firstImageLibSection should not be nil")
//        XCTAssertTrue(firstImageLibSection?.numberOfRowIn() == 1, "firstImageLibSection should have 3 numberOfSection")
        let expectedUrls = expected.compactMap{URL(string: $0)}
        for index in 0..<expectedUrls.count {
            let expectedUrl = expectedUrls[index]
            let imageSection = imageLibSection.sectionAt(index: index)
            XCTAssertTrue(imageSection != nil, "imageSection should not be nil")
            if let imageSection = imageSection {
                let url = (imageSection.itemFor(row: 0) as? ImageCellViewModelType)?.imageURL
                
                XCTAssertTrue(url?.absoluteURL == expectedUrl.absoluteURL, "imageURL should be equal to \(expectedUrl.absoluteString), not \(url?.absoluteString)")
                
            }
        }
    }
    
    fileprivate func assertOperationalHourFirstSection(_ operationalHourSection: CollapsibleSection?, _ expectedVM: OpenHoursFirstCellViewModel) {
        let firstRow = operationalHourSection?.itemFor(row: 0) as? OpenHoursFirstCellViewModel
        XCTAssertTrue(firstRow != nil, "firstRow should not be nil")
        if let firstRow = firstRow {
            XCTAssertTrue(firstRow.headingText.text == expectedVM.headingText.text, "headingText.text should be equal to '\(expectedVM.headingText.text)', not \(firstRow.headingText.text)")
            XCTAssertTrue(firstRow.subHeadingText == expectedVM.subHeadingText, "headingText.text should be equal to '\(expectedVM.subHeadingText)', not \(firstRow.subHeadingText)")
            XCTAssertTrue(firstRow.headingText.color == expectedVM.headingText.color, "headingText.color should be equal to '\(expectedVM.headingText.color)', not \(firstRow.headingText.color)")
        }
    }
    
    fileprivate func openingHours() -> [HeadingSubHeadingCellViewModel] {
        [
            HeadingSubHeadingCellViewModel(heading: WeekDay.tuesday.rawValue.capitalized, subHeading: "11:30 AM - 02:30 PM\n05:00 PM - 10:00 PM"),
            HeadingSubHeadingCellViewModel(heading: WeekDay.wednesday.rawValue.capitalized, subHeading: "11:30 AM - 02:30 PM\n05:00 PM - 10:00 PM"),
            HeadingSubHeadingCellViewModel(heading: WeekDay.thursday.rawValue.capitalized, subHeading: "11:30 AM - 02:30 PM\n05:00 PM - 11:00 PM"),
            HeadingSubHeadingCellViewModel(heading: WeekDay.friday.rawValue.capitalized, subHeading: "05:00 PM - 11:00 PM"),
            HeadingSubHeadingCellViewModel(heading: WeekDay.saturday.rawValue.capitalized, subHeading: "05:00 PM - 10:00 PM"),
            HeadingSubHeadingCellViewModel(heading: WeekDay.sunday.rawValue.capitalized, subHeading: "11:30 AM - 02:30 PM\n05:00 PM - 10:00 PM"),
            HeadingSubHeadingCellViewModel(heading: WeekDay.monday.rawValue.capitalized, subHeading: "11:30 AM - 02:30 PM\n05:00 PM - 10:00 PM")
        ]
    }
    
    fileprivate func assertOpeningHoursViewModels(_ operationalHourSection: CollapsibleSection?) {
        var openHourViewModels =  openingHours()
        
        for index in 0..<openHourViewModels.count {
            let expected = openHourViewModels[index]
            let actual = operationalHourSection?.itemFor(row: index + 1) as? HeadingSubHeadingCellViewModel
            XCTAssertTrue(actual == expected, "At \(index) (Open hour should be equal to \(expected.description), not \(actual?.description)")
        }
    }
    fileprivate func assertPhoneAndRatingSection(viewModel: ListViewModelProtocol) {
        let phoneAndRatingSection = viewModel.sectionAt(index: 2)
        XCTAssertTrue(phoneAndRatingSection != nil, "phoneAndRatingSection should not be nil")
        if let phoneAndRatingSection = phoneAndRatingSection {
            
            XCTAssertTrue(phoneAndRatingSection.numberOfRowIn() == 2, "phoneAndRatingSection should have only 2 row, not \(phoneAndRatingSection.numberOfRowIn())")
            let phoneItem = phoneAndRatingSection.itemFor(row: 0) as? HeadingSubHeadingCellViewModelType
            XCTAssertTrue(phoneItem != nil, "phoneItem should not be nil")
            
            if let phoneItem = phoneItem {
                XCTAssertTrue(phoneItem.heading == "Phone", "phoneItem.heading should be equal to Phone, not \(phoneItem.heading)")
                XCTAssertTrue(phoneItem.subHeading == "(415) 981-0983", "phoneItem.heading should be equal to (415) 981-0983, not \(phoneItem.subHeading)")
            }

            let ratingItem = phoneAndRatingSection.itemFor(row: 1) as? HeadingSubHeadingCellViewModelType
            XCTAssertTrue(ratingItem != nil, "ratingItem should not be nil")
            
            if let ratingItem = ratingItem {
                XCTAssertTrue(ratingItem.heading == "Review", "phoneItem.heading should be equal to Review, not \(ratingItem.heading)")
                XCTAssertTrue(ratingItem.subHeading == "4.5 ★(5012)", "phoneItem.heading should be equal to 4.5 ★(5012), not \(ratingItem.subHeading)")
            }

        }
    }
    
    fileprivate func assertNonCollapsedOperationalHoursSection( viewModel: BusinessesDetailViewModelType) {
        let operationalHourSection = viewModel.sectionAt(index: 2) as? CollapsibleSection
        XCTAssertTrue(operationalHourSection != nil, "operationalHourSection should not be nil")

        XCTAssertTrue(operationalHourSection?.numberOfRowIn() == 8, "operationalHourSection should have only 8 row, not \(operationalHourSection?.numberOfRowIn())")
        let expectedHeading = ColoredText(text: "Closed Now", color: .red)
        let expectedVM = OpenHoursFirstCellViewModel(headingText: expectedHeading, subHeadingText: "Opens at 05:00 PM")
        assertOperationalHourFirstSection(operationalHourSection, expectedVM)
        assertOpeningHoursViewModels(operationalHourSection)
    }
    
    fileprivate func assertOperationalHoursSection(viewModel: BusinessesDetailViewModelType) {
        let operationalHourSection = viewModel.sectionAt(index: 2) as? CollapsibleSection
        XCTAssertTrue(operationalHourSection != nil, "operationalHourSection should not be nil")
        XCTAssertTrue(operationalHourSection?.numberOfRowIn() == 1, "operationalHourSection should have only 1 row, not \(operationalHourSection?.numberOfRowIn())")
        
        let expectedHeading = ColoredText(text: "Closed Now", color: .red)
        let expectedVM = OpenHoursFirstCellViewModel(headingText: expectedHeading, subHeadingText: "Opens at 05:00 PM")
        assertOperationalHourFirstSection(operationalHourSection, expectedVM)

        viewModel.itemClicked(at: IndexPath(row: 0, section: 2))

        
    }
    
    fileprivate func secondSectionUpdated(viewModel: BusinessesDetailViewModelType) {
        assertNumberOfSection(viewModel, sectionCount: 3)
        let expected = [
            "https://s3-media2.fl.yelpcdn.com/bphoto/FTQfPJubJEtYeyHqwAsVKw/o.jpg",
            "https://s3-media2.fl.yelpcdn.com/bphoto/9lneWjyZG5BnQYZP9JNnlw/o.jpg",
            "https://s3-media1.fl.yelpcdn.com/bphoto/qYjEM7ZmOtGFDY1uwFY4ZQ/o.jpg"
          ]
        assertPhotoSection(viewModel, expected: expected)
        assertOperationalHoursSection(viewModel: viewModel)
    }
    
    fileprivate func thirdSectionUpdated(viewModel: BusinessesDetailViewModelType) {
        assertNumberOfSection(viewModel, sectionCount: 3)
        let expected = [
            "https://s3-media2.fl.yelpcdn.com/bphoto/FTQfPJubJEtYeyHqwAsVKw/o.jpg",
            "https://s3-media2.fl.yelpcdn.com/bphoto/9lneWjyZG5BnQYZP9JNnlw/o.jpg",
            "https://s3-media1.fl.yelpcdn.com/bphoto/qYjEM7ZmOtGFDY1uwFY4ZQ/o.jpg"
          ]
        assertPhotoSection(viewModel, expected: expected)
        assertNonCollapsedOperationalHoursSection(viewModel: viewModel)
    }
    
    func testAPISuccess() {
        networkSession.result = .success(businessId)
        var sectionUpdateCount = 0
        viewModel.name = businessName
        viewModel.sections.addObserver { [weak self] sections in
            guard let self = self else {
                return
            }
            sectionUpdateCount += 1
            switch sectionUpdateCount {
            case 1:
                self.firstSectionUpdated(viewModel: self.viewModel)
            case 2:
                self.secondSectionUpdated(viewModel: self.viewModel)
            case 3:
                self.thirdSectionUpdated(viewModel: self.viewModel)
                break
            default:
                XCTAssertTrue(sectionUpdateCount <= 2, "sectionUpdateCount should not be greater than 2")
            }
        }
        viewModel.getDetail()
        viewModel.sections.removeObserver()
        XCTAssertTrue(sectionUpdateCount == 3, "sectionUpdateCount should be 3")

    }
    
    func testEndPoint() {
        let endPoint = BusinessesDetailService.EndPoint.detail(id: businessId)
        let urlRequest = endPoint.urlRequest
        XCTAssertTrue(urlRequest != nil, "urlRequest should not be nil")
        if let urlRequest = urlRequest {
            XCTAssertTrue(urlRequest.url?.absoluteString == "https://api.yelp.com/v3/businesses/PsY5DMHxa5iNX_nX0T-qPA", "URL is not matching")
            
            for (key, value) in BaseHeader.baseHeader {
                let actualValue = urlRequest.allHTTPHeaderFields?[key]
                XCTAssertTrue(actualValue == value , "Header \(actualValue) is not matching to \(value)")
                
            }
        }
    }
    func testFailure() {
        networkSession.result = .failure("ValidattionError")
        var customErrorUpdateCount = 0

        viewModel.customError.addObserver { [weak self] string in
            guard let self = self else { return }
            customErrorUpdateCount += 1
            switch customErrorUpdateCount {
            case 1:
                let accpectedString: String? = nil
                self.assertCustomError(string, accpectedString)
            case 2:
                let accpectedString = "Please specify a location or a latitude and longitude"
                self.assertCustomError(string, accpectedString)
            default:
                break

            }
        }
        viewModel.getDetail()
        viewModel.sections.removeObserver()
        XCTAssertTrue(customErrorUpdateCount == 2, "customErrorUpdateCount should be 2")

    }
}

extension HeadingSubHeadingCellViewModel: Equatable {
    public static func == (lhs: BusinessesAroundMe.HeadingSubHeadingCellViewModel, rhs: BusinessesAroundMe.HeadingSubHeadingCellViewModel) -> Bool {
        return lhs.heading == rhs.heading && lhs.subHeading == rhs.subHeading
    }
}
extension HeadingSubHeadingCellViewModel: CustomStringConvertible {
    public var description: String {
        return "(\(heading)  \(subHeading))"
    }
}
