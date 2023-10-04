//
//  GifsViewController.swift
//  GiphyTestApp
//
//  Created by Vitaliy on 04.10.2023.
//

import UIKit

final class GifsViewController: UIViewController, GifListViewDelegate {

    private let gifListView = GifListView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Gifs"
        setUpView()
    }

    private func setUpView() {
        gifListView.delegate = self
        view.addSubview(gifListView)
        NSLayoutConstraint.activate([
            gifListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            gifListView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            gifListView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            gifListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    func gifDidSelected(_ gifListView: GifListView, didSelectGif gif: GifDataType) {
        let viewModel = GifDetailViewViewModel(gif: gif)
        let detailVC = GifDetailViewController(viewModel: viewModel)
        detailVC.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
