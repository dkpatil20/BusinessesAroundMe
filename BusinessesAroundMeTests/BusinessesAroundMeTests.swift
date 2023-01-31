//
//  BusinessesAroundMeTests.swift
//  BusinessesAroundMeTests
//
//  Created by Dhiraj Patil on 26/01/23.
//

import XCTest
@testable import BusinessesAroundMe

final class BusinessesAroundMeTests: XCTestCase, TestLoaderSection, CustomErrorTest {
    lazy var networkSession = MockNetworkSession()
    lazy var service: BusinessesSearchServiceType = BusinessesSearchService(
        apiService: APIService(
            networkSession: networkSession
        )
    )
    
    lazy var viewModel =
        BusinessesSearchViewModel(services: service)
    
}

extension BusinessesAroundMeTests {
    
    fileprivate func firstSectionWith20Items(_ viewModel: BusinessesSearchViewModelType) {
        XCTAssertTrue(viewModel.sectionAt(index: 0) != nil, "First Section should not be nil")
        XCTAssertTrue(viewModel.numberOfRowIn(section: 0) == 20, "Items in first Section should be 20, not \(viewModel.numberOfRowIn(section: 0))")
    }
    fileprivate func firstSectionWith40Items(_ viewModel: BusinessesSearchViewModelType) {
        XCTAssertTrue(viewModel.sectionAt(index: 0) != nil, "First Section should not be nil")
        XCTAssertTrue(viewModel.numberOfRowIn(section: 0) == 40, "Items in first Section should be 40, not \(viewModel.numberOfRowIn(section: 0))")
    }
}

extension BusinessesAroundMeTests {
    
    fileprivate func secondSectionUpdated(viewModel: BusinessesSearchViewModelType) {
        assertNumberOfSection(viewModel, sectionCount: 2)
        
        firstSectionWith20Items(viewModel)
        
        assertLoaderSection(viewModel, index: 1)
        
        let item = viewModel.itemAt(indexPath: IndexPath(row: 0, section: 0)) as? BusinessListViewModel
        let testItem = BusinessListViewModel(
            id: "Xg-FyjVKAN70LO4u4Z1ozg",
            name: "Hog Island Oyster",
            price: "Price: $$",
            imageURL: URL(string: "https://s3-media4.fl.yelpcdn.com/bphoto/Kozd3NJMSaT6S3J2kYAc1g/o.jpg"),
            rating: "4.5 ★"
        )
        assert(item, testItem)
    }
    
    
    fileprivate func secondSectionUpdatedWithPagination(viewModel: BusinessesSearchViewModelType) {
        assertNumberOfSection(viewModel, sectionCount: 2)

        firstSectionWith20Items(viewModel)
        assertLoaderSection(viewModel,index: 1)
        
        networkSession.result = .success("SucessPage2")
        
        let item = viewModel.itemAt(indexPath: IndexPath(row: 17, section: 0)) as? BusinessListViewModel
        let testItem = BusinessListViewModel(
            id: "tnhfDv5Il8EaGSXZGiuQGg",
            name: "Garaje",
            price: "Price: $$",
            imageURL: URL(string: "https://s3-media2.fl.yelpcdn.com/bphoto/RNCNNS1PCzp6ket6rZX8Cw/o.jpg"),
            rating: "4.5 ★"
        )
        assert(item, testItem)
        
    }
}

extension BusinessesAroundMeTests {
    fileprivate func thirdSectionUpdated(viewModel: BusinessesSearchViewModelType) {
        assertNumberOfSection(viewModel, sectionCount: 1)

        firstSectionWith40Items(viewModel)
        let item = viewModel.itemAt(indexPath: IndexPath(row: 37, section: 0)) as? BusinessListViewModel
        let testItem = BusinessListViewModel(
            id: "WavvLdfdP6g8aZTtbBQHTw",
            name: "Gary Danko",
            price: "Price: -",
            imageURL: URL(string: "https://s3-media3.fl.yelpcdn.com/bphoto/eyYUz3Xl7NtcJeN7x7SQwg/o.jpg"),
            rating: "4.5 ★"
        )
        assert(item, testItem)
        
    }
    
    func testEndPoint() {
        let queryItem = BusinessesSearchRequest(
            latitude: 37.786882,
            longitude: -122.399972,
            sortBy: .bestMatch,
            limit: 20,
            offset: 0,
            term: "restaurants"
        )

        let endPoint = BusinessesSearchService.EndPoint.search(queryItem: queryItem)
        let urlRequest = endPoint.urlRequest
        XCTAssertTrue(urlRequest != nil, "urlRequest should not be nil")
        if let urlRequest = urlRequest {
            let actualURL = URL(string: "https://api.yelp.com/v3/businesses/search?latitude=37.786882&limit=20&longitude=-122.399972&offset=0&sort_by=best_match&term=restaurants")
            XCTAssertTrue(urlRequest.url == actualURL, "URL \(urlRequest.url) is not matching to \(actualURL)")
            
            for (key, value) in BaseHeader.baseHeader {
                let actualValue = urlRequest.allHTTPHeaderFields?[key]
                XCTAssertTrue(actualValue == value , "Header \(actualValue) is not matching to \(value)")
                
            }
        }
    }
}



extension BusinessesAroundMeTests {
    fileprivate func assert(_ item: BusinessListViewModel?, _ testItem: BusinessListViewModel) {
        XCTAssertTrue(item != nil, "First item in first section should not be nil")
        XCTAssertTrue(item?.name == testItem.name, "name should be equal to '\(testItem.name)'")
        XCTAssertTrue(item?.price == testItem.price, "Pricing should be equal to '\(testItem.price)'")
        XCTAssertTrue(item?.imageURL == testItem.imageURL, "imageURL should be equal to '\(String(describing: testItem.imageURL))'")
        XCTAssertTrue(item?.rating == testItem.rating, "Pricing should be equal to '\(testItem.rating)'")
    }
}

extension BusinessesAroundMeTests {
    
    func testAPISucess() {
        networkSession.result = .success("SucessPage1")
        var sectionUpdateCount = 0
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
                
            default:
                XCTAssertTrue(sectionUpdateCount <= 2, "sectionUpdateCount should not be greater than 2")
            }
        }
        viewModel.searchBusiness()
        viewModel.sections.removeObserver()
        XCTAssertTrue(sectionUpdateCount == 2, "sectionUpdateCount should be 2")
        
    }
    
    func testAPISucessPagination() {
        networkSession.result = .success("SucessPage1")
        var sectionUpdateCount = 0
        viewModel.sections.addObserver { [weak self] sections in
            guard let self = self else {
                return
            }
            sectionUpdateCount += 1
            switch sectionUpdateCount {
            case 1:
                self.firstSectionUpdated(viewModel: self.viewModel)
            case 2:
                self.secondSectionUpdatedWithPagination(viewModel: self.viewModel)
                break
                
            case 3:
                self.thirdSectionUpdated(viewModel: self.viewModel)
                break
            default:
                XCTAssertTrue(sectionUpdateCount <= 3, "sectionUpdateCount should not be greater than 3")
            }
        }

        viewModel.searchBusiness()
        viewModel.sections.removeObserver()
        XCTAssertTrue(sectionUpdateCount == 3, "sectionUpdateCount should be 3")
    }
    
    func testSuccessEmpty() {
        networkSession.result = .success("SucessEmptyPage")
        var sectionUpdateCount = 0
        viewModel.sections.addObserver { [weak self] sections in
            guard let self = self else {
                return
            }
            sectionUpdateCount += 1
            switch sectionUpdateCount {
            case 1:
                self.firstSectionUpdated(viewModel: self.viewModel)
            case 2:
                self.assertNumberOfSection(self.viewModel, sectionCount: 0)
                
            default:
                XCTAssertTrue(sectionUpdateCount <= 2, "sectionUpdateCount should not be greater than 2")
            }
        }
        viewModel.searchBusiness()
        viewModel.sections.removeObserver()
        XCTAssertTrue(sectionUpdateCount == 2, "sectionUpdateCount should be 2")

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
        viewModel.searchBusiness()
        viewModel.sections.removeObserver()
        XCTAssertTrue(customErrorUpdateCount == 2, "customErrorUpdateCount should be 2")

    }
    
    func testFailure2() {
        networkSession.result = .failure("ValidattionError2")
        var customErrorUpdateCount = 0

        viewModel.customError.addObserver { [weak self] string in
            guard let self = self else { return }
            customErrorUpdateCount += 1
            switch customErrorUpdateCount {
            case 1:
                let accpectedString: String? = nil
                self.assertCustomError(string, accpectedString)
            case 2:
                let accpectedString = "'best_matchss' is not one of ['best_match', 'rating', 'review_count', 'distance']"
                self.assertCustomError(string, accpectedString)
            default:
                break

            }
        }
        viewModel.searchBusiness()
        viewModel.sections.removeObserver()
        XCTAssertTrue(customErrorUpdateCount == 2, "customErrorUpdateCount should be 2")

    }
    
    func testShouldCallAPI() {
        XCTAssertTrue(viewModel.shouldCallAPI(), "shouldCallAPI should return true")
        XCTAssertTrue(viewModel.shouldCallAPI() == false, "shouldCallAPI should not return true until we call apiCallFinished(total:)")
        viewModel.apiCallFinished(total: 40)
        XCTAssertTrue(viewModel.shouldCallAPI(), "shouldCallAPI should return true")
        viewModel.apiCallFinished(total: 40)
        XCTAssertTrue(viewModel.shouldCallAPI() == false, "shouldCallAPI should not return true because we have reached to total 40")
    }
}

extension BusinessListViewModel: CustomStringConvertible {
    public var description: String {
        return "(\(name), \(rating), \(imageURL), \(price))"
    }
}
