//
//  MainViewController.swift
//  CatJunkie-iOS
//
//  Created by e.vanags on 20/05/2019.
//  Copyright © 2019 esesmuedgars. All rights reserved.
//

import UIKit

final class MainViewController: UIViewController {

    @IBOutlet private var collectionView: UICollectionView! {
        didSet {
            let refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: #selector(fetchCatImages), for: .valueChanged)

            collectionView.refreshControl = refreshControl
        }
    }

    var viewModel: MainViewModel!

    weak var flowDelegate: FlowControllerDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.isNavigationBarHidden = true

        viewModel.delegate = self

        fetchCatImages()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    @objc
    func fetchCatImages() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true

        viewModel.fetchCatImages()
    }
}

// MARK: - MainViewModelDelegate

extension MainViewController: MainViewModelDelegate {

    func viewModelDidFetchCats() {
        collectionView.refreshControl?.endRefreshing()
        collectionView.reloadData()

        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }

    func viewModelFetchError(_ error: NetworkError) {
        presentErrorAlert(error) { [viewModel] in
            UIApplication.shared.isNetworkActivityIndicatorVisible = true

            viewModel?.fetchCatImages()
        }
    }
}

// MARK: - UICollectionViewDataSource

extension MainViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(CatCell.self, for: indexPath)

        viewModel.cellParameters(forCatAt: indexPath) { (identifier, data) in
            cell.configure(with: identifier, data: data)
        }


        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension MainViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let id = viewModel.cats[indexPath.row].id

        if let data = viewModel.cache.get(forKey: id) {
            flowDelegate?.presentVotingViewController(catId: id, data: data)
        }
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
