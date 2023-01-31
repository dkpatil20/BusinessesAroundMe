//
//  TestLoaderSection.swift
//  BusinessesAroundMe
//
//  Created by Dhiraj Patil on 31/01/23.
//

import XCTest
@testable import BusinessesAroundMe
protocol TestLoaderSection {
    func assertLoaderSection(_ viewModel: ListViewModelProtocol, index: Int)
}
extension TestLoaderSection where Self: XCTestCase {
    func assertLoaderSection(_ viewModel: ListViewModelProtocol, index: Int) {
        let loaderSection = viewModel.sectionAt(index: index)
        XCTAssertTrue(loaderSection != nil, "Loader Section should not be nil")
        XCTAssertTrue(loaderSection?.numberOfRowIn() == 1, "Items in Loader Section should be 1")
        let item = loaderSection?.itemFor(row: 0) as? LoaderTableViewCellViewModelType
        XCTAssertTrue(item != nil, "First item in Loader section should not be nil")
        XCTAssertTrue(item?.isLoading == true, "isLoading should be true")
    }
    func assertNumberOfSection(_ viewModel: ListViewModelProtocol, sectionCount: Int) {
        let numberOfSection = viewModel.numberOfSection()
        XCTAssertTrue(numberOfSection == sectionCount, "Number of section should \(sectionCount), not \(numberOfSection)")
    }
    func firstSectionUpdated(viewModel: ListViewModelProtocol) {
        assertNumberOfSection(viewModel, sectionCount: 1)
        assertLoaderSection(viewModel,index: 0)
    }

}
protocol CustomErrorTest {
    func assertCustomError(_ string: String?, _ accpectedString: String?)
}

extension CustomErrorTest {
    func assertCustomError(_ string: String?, _ accpectedString: String?) {
        XCTAssertTrue(string == accpectedString, "customError should be \(String(describing: accpectedString)), not \(String(describing: string))")
    }
}
