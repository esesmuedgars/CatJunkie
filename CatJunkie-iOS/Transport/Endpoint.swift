//
//  Endpoint.swift
//  CatJunkie-iOS
//
//  Created by e.vanags on 20/05/2019.
//  Copyright © 2019 esesmuedgars. All rights reserved.
//

import Foundation

enum Endpoint: String {
    case search = "v1/images/search"

    private var host: String {
        return "https://api.thecatapi.com"
    }
}

extension Endpoint {

    func url() -> URL {
        var url = URL(string: host)!
        url.appendPathComponent(rawValue)

        return url
    }

    func request(with queryItems: [URLQueryItem]? = nil) -> URLRequest {
        var components = URLComponents(url: url(), resolvingAgainstBaseURL: false)!
        components.queryItems = queryItems

        return URLRequest(url: components.url!)
    }
}
