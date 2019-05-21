//
//  MainFlowController.swift
//  CatJunkie-iOS
//
//  Created by e.vanags on 20/05/2019.
//  Copyright © 2019 esesmuedgars. All rights reserved.
//

import UIKit

protocol FlowController {
    func start()
}

extension FlowController {

    func setWindowRootViewController(_ viewController: UIViewController?) {
        assert(UIApplication.shared.keyWindow != nil, "Key window is nil")
        UIApplication.shared.keyWindow?.rootViewController = viewController
    }
}

protocol FlowControllerDelegate: class {
    func presentVotingViewController(cat: Cat)
    func presentAlertForCastedVote(voteType: Vote.`Type`)
}

final class MainFlowController: FlowController, FlowControllerDelegate {

    private var navigationController: UINavigationController!
    private lazy var storyboard = UIStoryboard(name: "Main", bundle: .main)

    func start() {
        presentMainViewController()
    }

    private func presentMainViewController() {
        let viewController = storyboard.instantiateViewController(MainViewController.self)
        viewController.viewModel = MainViewModel()
        viewController.flowDelegate = self

        if navigationController == nil {
            navigationController = UINavigationController(rootViewController: viewController)
            setWindowRootViewController(navigationController)
        } else {
            navigationController.pushViewController(viewController, animated: true)
        }
    }

    func presentVotingViewController(cat: Cat) {
        let viewController = storyboard.instantiateViewController(VotingViewController.self)
        viewController.viewModel = VotingViewModel(cat: cat)
        viewController.flowDelegate = self

        if navigationController == nil {
            navigationController = UINavigationController(rootViewController: viewController)
            setWindowRootViewController(navigationController)
        } else {
            navigationController.pushViewController(viewController, animated: true)
        }
    }

    func presentAlertForCastedVote(voteType: Vote.`Type`) {
        let alertController = UIAlertController(title: "Vote Casted!", message: "You have successfully \(voteType == .up ? "upvoted" : "downvoted") this image.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel))

        navigationController.present(alertController, animated: true)
    }
}
