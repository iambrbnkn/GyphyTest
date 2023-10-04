//
//  GifListViewViewModel.swift
//  GiphyTestApp
//
//  Created by Vitaliy on 04.10.2023.
//

import UIKit

protocol GifListViewViewModelDelegate: AnyObject {
    func didLoadInitialGifs()
    func didLoadMoreGifs(with newIndexPaths: [IndexPath])
    func didSelectGif(_ gif: GifDataType)
}

/// View Model to handle gif list view logic
final class GifListViewViewModel: NSObject {

    public weak var delegate: GifListViewViewModelDelegate?
    
    private var apiService: ApiServiceProtocol = ApiService()

    private var isLoadingMoreGifs = false

    private var gifs: [GifDataType] = [] {
        didSet {
            for gif in gifs {
                let viewModel = GifCollectionViewCellViewModel(
                    gifID: gif.id,
                    gifImageUrl: URL(string: gif.images.fixedWidth.url)
                )
                if !cellViewModels.contains(viewModel) {
                    cellViewModels.append(viewModel)
                }
            }
        }
    }

    private var cellViewModels: [GifCollectionViewCellViewModel] = []

    private var totalGifsCount: Int = 0
    
    private var currentOffset: Int = 0

    public func fetchGifs() {
        apiService.execute(withOffset: currentOffset) { [weak self] result in
            switch result {
            case .success(let responseModel):
                let results = responseModel.data
                let info = responseModel.pagination.totalCount
                self?.gifs = results
                self?.totalGifsCount = info
                DispatchQueue.main.async {
                    self?.delegate?.didLoadInitialGifs()
                }
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }

    public func fetchAdditionalGifs() {
        guard !isLoadingMoreGifs else {
            return
        }
        isLoadingMoreGifs = true
        currentOffset += 20
        
        apiService.execute(withOffset: currentOffset) { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            switch result {
            case .success(let responseModel):
                let moreResults = responseModel.data
                let info = responseModel.pagination.totalCount
                strongSelf.totalGifsCount = info

                let originalCount = strongSelf.gifs.count
                let newCount = moreResults.count
                let total = originalCount+newCount
                let startingIndex = total - newCount
                let indexPathsToAdd: [IndexPath] = Array(startingIndex..<(startingIndex+newCount)).compactMap({
                    return IndexPath(row: $0, section: 0)
                })
                strongSelf.gifs.append(contentsOf: moreResults)

                DispatchQueue.main.async {
                    strongSelf.delegate?.didLoadMoreGifs(
                        with: indexPathsToAdd
                    )
                    strongSelf.isLoadingMoreGifs = false
                }
            case .failure(let failure):
                print(String(describing: failure))
                self?.isLoadingMoreGifs = false
            }
        }
    }

    public var shouldShowLoadMoreIndicator: Bool {
        return totalGifsCount - currentOffset != 0
    }
}

// MARK: - CollectionView

extension GifListViewViewModel: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellViewModels.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: GifDataTypeCollectionViewCell.cellIdentifier,
            for: indexPath
        ) as? GifDataTypeCollectionViewCell else {
            fatalError("Unsupported cell")
        }
        cell.configure(with: cellViewModels[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionFooter,
              let footer = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: FooterLoadingView.identifier,
                for: indexPath
              ) as? FooterLoadingView else {
            fatalError("Unsupported")
        }
        footer.startAnimating()
        return footer
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard shouldShowLoadMoreIndicator else {
            return .zero
        }

        return CGSize(width: collectionView.frame.width,
                      height: 100)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let bounds = collectionView.bounds
        let width: CGFloat = (bounds.width-30)/2

        return CGSize(
            width: width,
            height: width * 1.5
        )
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let gif = gifs[indexPath.row]
        delegate?.didSelectGif(gif)
    }
}

// MARK: - ScrollView
extension GifListViewViewModel: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard shouldShowLoadMoreIndicator,
              !isLoadingMoreGifs,
              !cellViewModels.isEmpty
        else {
            return
        }
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [weak self] t in
            let offset = scrollView.contentOffset.y
            let totalContentHeight = scrollView.contentSize.height
            let totalScrollViewFixedHeight = scrollView.frame.size.height

            if offset >= (totalContentHeight - totalScrollViewFixedHeight - 120) {
                self?.fetchAdditionalGifs()
            }
            t.invalidate()
        }
    }
}
