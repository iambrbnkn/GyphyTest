//
//  GifDetailViewController.swift
//  GiphyTestApp
//
//  Created by Vitaliy on 04.10.2023.
//

import UIKit

final class GifDetailViewController: UIViewController {
    private let viewModel: GifDetailViewViewModel

    private let detailView: GifDetailView

    // MARK: - Init

    init(viewModel: GifDetailViewViewModel) {
        self.viewModel = viewModel
        self.detailView = GifDetailView(frame: .zero, viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(detailView)
        addConstraints()
        addShareButton()
    }
    
    private func addShareButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self, action: #selector(didTapShare)
        )
    }
    
    @objc private func didTapShare() {
        let item = [viewModel.shareUrl]
        let ac = UIActivityViewController(activityItems: item, applicationActivities: nil)
        present(ac, animated: true)
    }

    private func addConstraints() {
        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            detailView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            detailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}
