//
//  MainViewModel.swift
//  CatJunkie-iOS
//
//  Created by e.vanags on 20/05/2019.
//  Copyright © 2019 esesmuedgars. All rights reserved.
//

import Foundation
import UIKit

protocol MainViewModelDelegate: class {
    func viewModelDidFetchCats()
    func viewModelFetchError(_ error: NetworkError)
}

final class MainViewModel {

    private let apiService: APIServiceProtocol

    weak var delegate: MainViewModelDelegate!

    private var cacheWorkItem: DispatchWorkItem!

    var cats = Cats() {
        didSet {
            mainThread { [weak self] in
                self?.cacheWorkItem?.cancel()
                self?.cache.clear()

                self?.delegate?.viewModelDidFetchCats()
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
                    self?.delegate?.viewModelFetchError(error)
                }
            }
        }
    }

    func cellParameters(forCatAt indexPath: IndexPath, completionHandler complete: @escaping (String, NSData?) -> Void) {
        let cat = cats[indexPath.row]

        if let data = cache.get(forKey: cat.id) {
            complete(cat.id, data)
        } else {
            cacheWorkItem = DispatchWorkItem { [cache] in
                if let url = URL(string: cat.url), let data = NSData(contentsOf: url) {
                    cache.set(data, forKey: cat.id)

                    mainThread {
                        complete(cat.id, data)
                    }
                } else {
                    if let data: NSData = .default {
                        cache.set(data, forKey: cat.id)

                        mainThread {
                            complete(cat.id, data)
                        }
                    }
                }
            }
            backgroundThread(qos: .utility, cacheWorkItem)
        }
    }

    func numberOfItems() -> Int {
        return cats.count
    }
}
