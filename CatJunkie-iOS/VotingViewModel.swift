//
// VotingViewModel.swift
//  CatJunkie-iOS
//
//  Created by e.vanags on 20/05/2019.
//  Copyright © 2019 esesmuedgars. All rights reserved.
//

import Foundation

final class VotingViewModel {

    let cat: Cat
    private let apiService: APIServiceProtocol

    init(cat: Cat, apiService: APIServiceProtocol = APIService.shared) {
        self.cat = cat
        self.apiService = apiService
    }
}
