//
//  GifCollectionViewCellViewModel.swift
//  GiphyTestApp
//
//  Created by Vitaliy on 04.10.2023.
//

import Foundation

final class GifCollectionViewCellViewModel: Hashable, Equatable {
    
    private let gifID: String
    
    private let gifImageUrl: URL?

    // MARK: - Init

    init(
        gifID: String,
        gifImageUrl: URL?
    ) {
        self.gifID = gifID
        self.gifImageUrl = gifImageUrl
    }

    public func fetchImage(completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = gifImageUrl else {
            return
        }
        ImageLoader.shared.downloadImage(url, completion: completion)
    }

    // MARK: - Hashable

    static func == (lhs: GifCollectionViewCellViewModel, rhs: GifCollectionViewCellViewModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(gifID)
        hasher.combine(gifImageUrl)
    }
}
