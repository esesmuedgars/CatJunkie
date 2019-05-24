//
//  MainViewModel.swift
//  CatJunkie-iOS
//
//  Created by e.vanags on 20/05/2019.
//  Copyright © 2019 esesmuedgars. All rights reserved.
//

import Foundation

protocol MainViewModelDelegate: class {
    func viewModelDidFetchCats()
    func viewModelDidCache(catAt index: Int)
    func viewModelFetchError(_ error: NetworkError)
}

final class MainViewModel {

    private let apiService: APIServiceProtocol

    weak var delegate: MainViewModelDelegate!

    var cats = Cats() {
        didSet {
            mainThread { [cache, delegate] in
                cache.clear()
                delegate?.viewModelDidFetchCats()
            }

            backgroundThread(qos: .utility) { [weak self] in
                self?.cacheCats()
            }
        }
    }

    lazy var cache: NSCache<NSString, NSData> = {
        let cache = NSCache<NSString, NSData>()
        cache.countLimit = 40

        return cache
    }()

    init(apiService: APIServiceProtocol = APIService.shared) {
        self.apiService = apiService
    }

    func fetchCatImages() {
        apiService.fetchCatImages { [weak self] result in
            switch result {
            case .success(let cats):
                self?.cats = cats
            case .failure(let error):
                mainThread {
                    self?.delegate.viewModelFetchError(error)
                }
            }
        }
    }

    private func cacheCats() {
        for (index, cat) in cats.enumerated() {
            if let url = URL(string: cat.url), let data = NSData(contentsOf: url), cache.get(forKey: cat.id) == nil {
                cache.set(data, forKey: cat.id)
            }

            mainThread { [delegate] in
                delegate?.viewModelDidCache(catAt: index)
            }
        }
    }

    func cat(at indexPath: IndexPath) -> Cat {
        return cats[indexPath.row]
    }

    func numberOfItems() -> Int {
        return cats.count
    }
}
