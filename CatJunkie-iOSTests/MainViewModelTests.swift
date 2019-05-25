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
        XCTAssertEqual(viewModel.cat(at: IndexPath(row: 1, section: 0)), cats[1], "Cat objects at index 1 did not satisfy expectation.")
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
}
