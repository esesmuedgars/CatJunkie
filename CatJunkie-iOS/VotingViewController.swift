//
//  VotingViewController.swift
//  CatJunkie-iOS
//
//  Created by e.vanags on 20/05/2019.
//  Copyright © 2019 esesmuedgars. All rights reserved.
//

import UIKit

final class VotingViewController: UIViewController {

    var viewModel: VotingViewModel!

    weak var flowDelegate: FlowControllerDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}
