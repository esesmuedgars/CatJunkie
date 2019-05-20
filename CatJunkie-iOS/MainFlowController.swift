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
    func presentRatingViewController()
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

    func presentRatingViewController() {
        let viewController = storyboard.instantiateViewController(RatingViewController.self)
        viewController.viewModel = RatingViewModel()

        if navigationController == nil {
            navigationController = UINavigationController(rootViewController: viewController)
            setWindowRootViewController(navigationController)
        } else {
            navigationController.pushViewController(viewController, animated: true)
        }
    }
}
