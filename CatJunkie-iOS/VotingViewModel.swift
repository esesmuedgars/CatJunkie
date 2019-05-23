//
// VotingViewModel.swift
//  CatJunkie-iOS
//
//  Created by e.vanags on 20/05/2019.
//  Copyright © 2019 esesmuedgars. All rights reserved.
//

import Foundation

protocol VotingViewModelDelegate: class {
    func viewModelDidFetchVotes()
    func viewModelDidFetchVote(_ voteType: Vote.`Type`)
    func viewModelDidCastVote(_ voteType: Vote.`Type`)
}

final class VotingViewModel {

    let catId: String
    let data: NSData
    private let apiService: APIServiceProtocol

    weak var delegate: VotingViewModelDelegate!

    var vote: Vote? {
        didSet {
            guard let vote = vote else { return }

            mainThread { [delegate] in
                delegate?.viewModelDidFetchVote(vote.type)
            }
        }
    }

    init(catId: String, data: NSData, apiService: APIServiceProtocol = APIService.shared) {
        self.catId = catId
        self.data = data
        self.apiService = apiService
    }

    func fetchCatImageVote() {
        // TODO:
        // Is `.userInitiated` quality of service behaving is better than `.default`?
        // https://developer.apple.com/library/archive/documentation/Performance/Conceptual/EnergyGuide-iOS/PrioritizeWorkWithQoS.html
        backgroundThread(qos: .userInitiated) { [weak self] in
            self?.apiService.fetchCatImageVotes { [weak self] result in
                switch result {
                case .success(let votes):
                    mainThread {
                        self?.delegate.viewModelDidFetchVotes()
                    }

                    if let id = self?.catId, let vote = votes.first(where: { $0.id == id }) {
                        self?.vote = vote
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }

    func voteForCatImage(voteType: Vote.`Type`) {
        backgroundThread(qos: .userInitiated) { [weak self] in
            guard let id = self?.catId else { return }

            self?.apiService.voteForCatImage(withId: id, voteType: voteType) { [weak self] result in
                switch result {
                case .success:
                    mainThread {
                        self?.delegate.viewModelDidCastVote(voteType)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}
