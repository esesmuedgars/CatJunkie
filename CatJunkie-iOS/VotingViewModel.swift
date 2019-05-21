//
// VotingViewModel.swift
//  CatJunkie-iOS
//
//  Created by e.vanags on 20/05/2019.
//  Copyright © 2019 esesmuedgars. All rights reserved.
//

import Foundation

final class VotingViewModel {

    private let catId: String
    private let apiService: APIServiceProtocol

    init(catId: String, apiService: APIServiceProtocol = APIService.shared) {
        self.catId = catId
        self.apiService = apiService
    }
}
