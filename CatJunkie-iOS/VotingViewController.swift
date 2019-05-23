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
            imageView.layer.cornerRadius = 10

            if let data = viewModel.data as Data? {
                imageView.image = UIImage(data: data)
            } else {
                // FIXME: Set default image
                imageView.image = nil
            }
        }
    }

    @IBOutlet private var upvoteButton: UIButton!
    @IBOutlet private var downvoteButton: UIButton!

    var viewModel: VotingViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(false, animated: true)

        viewModel.delegate = self

        UIApplication.shared.isNetworkActivityIndicatorVisible = true

        viewModel.fetchCatImageVote()
    }

    @IBAction func didTapUpvote() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true

        viewModel.voteForCatImage(voteType: .up)
    }

    @IBAction func didTapDownvote() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true

        viewModel.voteForCatImage(voteType: .down)
    }
}

// MARK: - VotingViewModelDelegate

extension VotingViewController: VotingViewModelDelegate {

    func viewModelDidFetchVotes() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }

    func viewModelDidFetchVote(_ voteType: Vote.`Type`) {
        switch voteType {
        case .up:
            upvoteButton.isSelected = true
            downvoteButton.isSelected = false
        case .down:
            upvoteButton.isSelected = false
            downvoteButton.isSelected = true
        }
    }

    func viewModelDidCastVote(_ voteType: Vote.`Type`) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false

        viewModel.fetchCatImageVote()
//        let alertController = UIAlertController(title: "Vote has been Cast!", message: "You have successfully \(voteType == .up ? "upvoted" : "downvoted") this image.", preferredStyle: .alert)
//        alertController.addAction(UIAlertAction(title: "OK", style: .default))
//
//        present(alertController, animated: true)
    }
}
