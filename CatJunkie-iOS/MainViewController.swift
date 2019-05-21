//
//  MainViewController.swift
//  CatJunkie-iOS
//
//  Created by e.vanags on 20/05/2019.
//  Copyright © 2019 esesmuedgars. All rights reserved.
//

import UIKit

final class MainViewController: UIViewController {

    @IBOutlet private var collectionView: UICollectionView!

    var viewModel: MainViewModel!

    weak var flowDelegate: FlowControllerDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.isNavigationBarHidden = true

        viewModel.delegate = self

        UIApplication.shared.isNetworkActivityIndicatorVisible = true

        viewModel.fetchCatImages()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: true)
    }
}

// MARK: - MainViewModelDelegate

extension MainViewController: MainViewModelDelegate {

    func viewModelDidFetch() {
        collectionView.reloadData()

        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

// MARK: - UICollectionViewDataSource

extension MainViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(CatCell.self, for: indexPath)
        cell.configure(with: viewModel.cats[indexPath.row])

        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension MainViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        flowDelegate.presentVotingViewController(cat: viewModel.cats[indexPath.row])
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let horizontalInsets = flowLayout.sectionInset.left + flowLayout.sectionInset.right
        let constant = (collectionView.bounds.width - horizontalInsets - flowLayout.minimumInteritemSpacing) / 2

        return CGSize(width: constant, height: constant)
    }
}
