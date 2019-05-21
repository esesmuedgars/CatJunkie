//
// VotingViewModel.swift
//  CatJunkie-iOS
//
//  Created by e.vanags on 20/05/2019.
//  Copyright © 2019 esesmuedgars. All rights reserved.
//

import Foundation

protocol VotingViewModelDelegate: class {
    func viewModelDidFetchVote(_ vote: Vote)
    func viewModelDidCastVote(_ voteType: Vote.`Type`)
}

final class VotingViewModel {

    let cat: Cat
    private let apiService: APIServiceProtocol

    weak var delegate: VotingViewModelDelegate!

    var vote: Vote? {
        didSet {
            guard let vote = vote else { return }

            mainThread { [delegate] in
                delegate?.viewModelDidFetchVote(vote)
            }
        }
    }

    init(cat: Cat, apiService: APIServiceProtocol = APIService.shared) {
        self.cat = cat
        self.apiService = apiService
    }

    func fetchCatImageVote() {
        apiService.fetchCatImageVotes { [weak self, cat] result in
            switch result {
            case .success(let votes):
                if let vote = votes.first(where: { $0.id == cat.id }) {
                    self?.vote = vote
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    func voteForCatImage(voteType: Vote.`Type`) {
        apiService.voteForCatImage(withId: cat.id, voteType: voteType) { [delegate] result in
            switch result {
            case .success:
                delegate?.viewModelDidCastVote(voteType)
            case .failure(let error):
                print(error)
            }
        }
    }
}
