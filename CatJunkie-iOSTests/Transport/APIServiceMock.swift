//
//  APIServiceMock.swift
//  CatJunkie-iOS
//
//  Created by e.vanags on 25/05/2019.
//  Copyright © 2019 esesmuedgars. All rights reserved.
//

import Foundation

final class APIServiceMock: APIServiceProtocol {

    var fetchCatsResponse: ((cats: Cats, error: NetworkError?))?
    var fetchVotesResponse: ((votes: Votes, error: NetworkError?))?
    var castVoteResponse: NetworkError?

    func fetchCatImages(completionHandler complete: @escaping (Result<Cats, NetworkError>) -> Void) {
        guard let response = fetchCatsResponse else { return }

        guard response.error == nil else {
            complete(.failure(response.error.unsafelyUnwrapped))
            return
        }

        complete(.success(response.cats))
    }

    func fetchCatImageVotes(completionHandler complete: @escaping (Result<Votes, NetworkError>) -> Void) {
        guard let response = fetchVotesResponse else { return }

        guard response.error == nil else {
            complete(.failure(response.error.unsafelyUnwrapped))
            return
        }

        complete(.success(response.votes))
    }

    func voteForCatImage(withId id: String, voteType: Vote.`Type`, completionHandler complete: @escaping (Result<Void, NetworkError>) -> Void) {
        let error = castVoteResponse

        guard error == nil else {
            complete(.failure(error.unsafelyUnwrapped))
            return
        }

        complete(.success(()))
    }
}
