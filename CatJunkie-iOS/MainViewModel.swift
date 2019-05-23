//
//  MainViewModel.swift
//  CatJunkie-iOS
//
//  Created by e.vanags on 20/05/2019.
//  Copyright © 2019 esesmuedgars. All rights reserved.
//

import Foundation

protocol MainViewModelDelegate: class {
    func viewModelDidFetch()
}

final class MainViewModel {

    private let apiService: APIServiceProtocol

    weak var delegate: MainViewModelDelegate!

    var cats = Cats() {
        didSet {
            mainThread { [delegate] in
                delegate?.viewModelDidFetch()
            }
        }
    }

    init(apiService: APIServiceProtocol = APIService.shared) {
        self.apiService = apiService
    }

    func fetchCatImages() {
        apiService.fetchCatImages { [weak self] result in
            switch result {
            case .success(let cats):
                self?.cats = cats
            case .failure(let error):
                print(error)
            }
        }
    }

    func numberOfItems() -> Int {
        return cats.count
    }
}
