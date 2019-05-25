//
//  VotingViewModelTests.swift
//  CatJunkie-iOSTests
//
//  Created by e.vanags on 25/05/2019.
//  Copyright © 2019 esesmuedgars. All rights reserved.
//

import XCTest
@testable import CatJunkie_iOS

final class VotingViewModelTests: XCTestCase {

    private var apiService: APIServiceMock!

    override func setUp() {
        apiService = APIServiceMock()
    }

    override func tearDown() {
        apiService = nil
    }

    func testFetchCatImageVoteSuccess() {
        let votes = [
            Vote(id: "1", userId: "id", .up),
            Vote(id: "2", userId: "id", .up),
            Vote(id: "3", userId: "id", .up)
        ]

        let expected = votes[0]

        apiService.fetchVotesResponse = (votes: votes, error: nil)

        let viewModel = VotingViewModel(catId: expected.id, data: NSData(), apiService: apiService)
        viewModel.fetchCatImageVote()

        wait(for: [], timeout: 1)

        XCTAssertEqual(viewModel.vote, expected, "Expected: \(expected). Received: \(String(describing: viewModel.vote ?? nil)).")
    }

    func testFetchCatImageVoteFailure() {
        apiService.fetchVotesResponse = (votes: [], error: .emptyDataOrError)

        let viewModel = VotingViewModel(catId: String(), data: NSData(), apiService: apiService)
        viewModel.fetchCatImageVote()

        XCTAssertNil(viewModel.vote, "Expected vote object to be nil, actuakky: \(viewModel.vote.unsafelyUnwrapped).")
    }

    func testVoteForCatImageSuccess() {
        let expected = expectation(description: "Expect delegate receives object.")

        apiService.castVoteResponse = nil

        let viewModel = VotingViewModel(catId: String(), data: NSData(), apiService: apiService)
        viewModel.voteForCatImage(voteType: .up)

        expected.fulfill()

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testVoteForCatImageFailure() {
        let expected = expectation(description: "Expect delegate receives error.")

        apiService.castVoteResponse = .emptyDataOrError

        let viewModel = VotingViewModel(catId: String(), data: NSData(), apiService: apiService)
        viewModel.voteForCatImage(voteType: .up)

        expected.fulfill()

        waitForExpectations(timeout: 1, handler: nil)
    }
}
