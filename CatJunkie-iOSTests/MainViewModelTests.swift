//
//  MainViewModelTests.swift
//  CatJunkie-iOSTests
//
//  Created by e.vanags on 25/05/2019.
//  Copyright © 2019 esesmuedgars. All rights reserved.
//

import XCTest
@testable import CatJunkie_iOS

final class MainViewModelTests: XCTestCase {

    private var apiService: APIServiceMock!

    override func setUp() {
        apiService = APIServiceMock()
    }

    override func tearDown() {
        apiService = nil
    }

    func testFetchCatImagesResultIsSuccess() {
        let cats = [
            Cat(id: "1", url: ""),
            Cat(id: "2", url: ""),
            Cat(id: "3", url: ""),
            Cat(id: "4", url: ""),
            Cat(id: "5", url: "")
        ]

        apiService.fetchCatsResponse = (cats: cats, error: nil)

        let viewModel = MainViewModel(apiService: apiService)
        viewModel.fetchCatImages()

        XCTAssertEqual(viewModel.numberOfItems(), cats.count, "Number of items did not match. Expected: \(viewModel.numberOfItems()). Received: \(cats.count).")
        XCTAssertEqual(viewModel.cats, cats, "Array of items does not match expected. Expected: \(cats). Received: \(viewModel.cats).")
    }

    func testFetchCatImagesResultIsFailure() {
        apiService.fetchCatsResponse = (cats: [], error: .emptyDataOrError)

        let viewModel = MainViewModel(apiService: apiService)
        viewModel.fetchCatImages()

        XCTAssertTrue(viewModel.cats.isEmpty, "Expected array of items to be empty. Actually: \(viewModel.cats).")
    }

    func testViewModelCacheMethods() {
        let key = "key"
        let expected = "expected".data(using: .utf8)! as NSData

        let viewModel = MainViewModel(apiService: apiService)
        viewModel.cache.set(expected, forKey: key)

        let cacheValue = viewModel.cache.get(forKey: key)
        XCTAssertNotNil(cacheValue, "Item not found in cache.")
        XCTAssertEqual(cacheValue, expected, "Expected: \(String(describing: cacheValue ?? nil)). Received: \(expected).")

        viewModel.cache.clear()

        XCTAssertNil(viewModel.cache.get(forKey: key), "Expected cache to not contain item.")
    }

    func testCellParametersReturnsCachedData() {
        let expected = expectation(description: "Expect completion handler execution.")

        let cat = Cat(id: "1", url: "")
        let data = "data".data(using: .utf8)! as NSData

        apiService.fetchCatsResponse = (cats: [cat], error: nil)

        let viewModel = MainViewModel(apiService: apiService)
        viewModel.fetchCatImages()

        viewModel.cache.set(data, forKey: cat.id)

        viewModel.cellParameters(forCatAt: IndexPath(row: 0, section: 0)) { id, receivedData in
            XCTAssertEqual(receivedData, data, "Expected: \(data), received: \(receivedData.unsafelyUnwrapped).")

            expected.fulfill()
        }

        viewModel.cache.clear()

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testCellParametersReturnsData() {
        let cats = [
            Cat(id: "1", url: "https://www.apple.com/"),
            Cat(id: "2", url: "https://www.apple.com/"),
            Cat(id: "3", url: "https://www.apple.com/")
        ]

        apiService.fetchCatsResponse = (cats: cats, error: nil)

        let viewModel = MainViewModel(apiService: apiService)
        viewModel.fetchCatImages()

        let expected = [
            expectation(description: "Expect first completion handler execution."),
            expectation(description: "Expect second completion handler execution."),
            expectation(description: "Expect third completion handler execution.")
        ]

        for index in 0 ..< cats.count {
            viewModel.cellParameters(forCatAt: IndexPath(row: index, section: 0)) { id, data in
                XCTAssertNotNil(data, "Expected data to equal value, but received nil.")
                XCTAssertNotEqual(data, NSData.default, "Expected data to have unique value, but received placeholder value.")

                expected[index].fulfill()
            }
        }

        viewModel.cache.clear()

        wait(for: expected, timeout: 30)
    }

    func testCellParametersReturnsPlaceholder() {
        let cats = [
            Cat(id: "1", url: ""),
            Cat(id: "2", url: ""),
            Cat(id: "3", url: "")
        ]

        apiService.fetchCatsResponse = (cats: cats, error: nil)

        let viewModel = MainViewModel(apiService: apiService)
        viewModel.fetchCatImages()

        let expected = [
            expectation(description: "Expect first completion handler execution."),
            expectation(description: "Expect second completion handler execution."),
            expectation(description: "Expect third completion handler execution.")
        ]

        for index in 0 ..< cats.count {
            viewModel.cellParameters(forCatAt: IndexPath(row: index, section: 0)) { id, data in
                XCTAssertEqual(id, cats[index].id, "Expected: \(id). Received: \(cats[index].id).")
                XCTAssertEqual(data, NSData.default, "Expected: \(data.unsafelyUnwrapped). Received: \(NSData.default.unsafelyUnwrapped).")

                expected[index].fulfill()
            }
        }

        viewModel.cache.clear()

        wait(for: expected, timeout: 30)
    }
}
