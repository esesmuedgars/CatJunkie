//
//  VotingViewController.swift
//  CatJunkie-iOS
//
//  Created by e.vanags on 20/05/2019.
//  Copyright © 2019 esesmuedgars. All rights reserved.
//

import UIKit

final class VotingViewController: UIViewController {

    @IBOutlet private var imageView: UIImageView! {
        didSet {
            // NOTE: Should pass initiated `UIImage` instead of `Cat` url?

            backgroundThread { [weak self] in
                let image = UIImage(url: self?.viewModel.cat.url)

                mainThread {
                    self?.imageView.image = image
                }
            }
        }
    }

    var viewModel: VotingViewModel!

    weak var flowDelegate: FlowControllerDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(false, animated: true)

        viewModel.delegate = self

        UIApplication.shared.isNetworkActivityIndicatorVisible = true

        viewModel.fetchCatImageVote()
    }
}

// MARK: - VotingViewModelDelegate

extension VotingViewController: VotingViewModelDelegate {

    func viewModelDidFetchVote(_ vote: Vote) {
        // TODO: Populate UI elements

        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }

    func viewModelDidCastVote(_ voteType: Vote.`Type`) {
        // NOTE: Is this the right way to go about this?

        UIApplication.shared.isNetworkActivityIndicatorVisible = false

        flowDelegate.presentAlertForCastedVote(voteType: voteType)
    }
}
