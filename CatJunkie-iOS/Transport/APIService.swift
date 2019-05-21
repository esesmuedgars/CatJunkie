//
//  APIService.swift
//  CatJunkie-iOS
//
//  Created by e.vanags on 21/05/2019.
//  Copyright © 2019 esesmuedgars. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case emptyDataOrError
    case unexpectedStatusCode(statusCode: Int)
    case unableToParseDataWith(errorDescription: String)
    case failedToSerializeObjectWith(errorDescription: String)
}

protocol APIServiceProtocol {
    func fetchCatImages(completionHandler complete: @escaping (Result<Cats, NetworkError>) -> Void)
    func fetchCatImageVotes(completionHandler complete: @escaping (Result<Votes, NetworkError>) -> Void)
    func voteForCatImage(withId id: String, voteType: Vote.`Type`, completionHandler complete: @escaping (Result<Void, NetworkError>) -> Void)
}

final class APIService: APIServiceProtocol {

    /// API key used to make authenticated requests.
    /// Can be passed as a header or a query parameter.
    ///
    /// API key can be obtained by signing up at [TheCatAPI](https://thecatapi.com/).
    private let apiKey = "<#String#>"

    /// Limit of `Cat` model objects to fetch.
    private let limit = "40"

    /// Unique user identifier used to store and retrieve casted votes.
    private let userId = "210520190233-1"

    func fetchCatImages(completionHandler complete: @escaping (Result<Cats, NetworkError>) -> Void) {
        let parameters = [URLQueryItem(name: "limit", value: limit)]

        var request = Endpoint.search.request(with: parameters)
        request.addValue(apiKey, forHTTPHeaderField: "x-api-key")

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, let response = response as? HTTPURLResponse, error == nil else {
                complete(.failure(.emptyDataOrError))
                return
            }

            guard 200 ..< 300 ~= response.statusCode else {
                complete(.failure(.unexpectedStatusCode(statusCode: response.statusCode)))
                return
            }

            do {
                complete(.success(try JSONDecoder().decode(Cats.self, from: data)))
            } catch let error as NSError {
                complete(.failure(.unableToParseDataWith(errorDescription: error.debugDescription)))
            }
        }.resume()
    }

    func fetchCatImageVotes(completionHandler complete: @escaping (Result<Votes, NetworkError>) -> Void) {
        let parameters = [URLQueryItem(name: "sub_id", value: userId)]

        var request = Endpoint.vote.request(with: parameters)
        request.addValue(apiKey, forHTTPHeaderField: "x-api-key")

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, let response = response as? HTTPURLResponse, error == nil else {
                complete(.failure(.emptyDataOrError))
                return
            }

            guard 200 ..< 300 ~= response.statusCode else {
                complete(.failure(.unexpectedStatusCode(statusCode: response.statusCode)))
                return
            }

            do {
                complete(.success(try JSONDecoder().decode(Votes.self, from: data)))
            } catch let error as NSError {
                complete(.failure(.failedToSerializeObjectWith(errorDescription: error.debugDescription)))
            }
        }.resume()
    }

    func voteForCatImage(withId id: String, voteType: Vote.`Type`, completionHandler complete: @escaping (Result<Void, NetworkError>) -> Void) {
        var request = Endpoint.vote.request()
        request.addValue(apiKey, forHTTPHeaderField: "x-api-key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"

        do {
            request.httpBody = try JSONEncoder().encode(Vote(id: id, userId: userId, voteType))
        } catch let error as NSError {
            complete(.failure(.failedToSerializeObjectWith(errorDescription: error.debugDescription)))
        }

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard data != nil, let response = response as? HTTPURLResponse, error == nil else {
                complete(.failure(.emptyDataOrError))
                return
            }

            guard 200 ..< 300 ~= response.statusCode else {
                complete(.failure(.unexpectedStatusCode(statusCode: response.statusCode)))
                return
            }

            complete(.success(()))
        }.resume()
    }
}
