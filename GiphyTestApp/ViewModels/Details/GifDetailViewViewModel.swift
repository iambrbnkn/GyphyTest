//
//  GifDetailViewViewModel.swift
//  GiphyTestApp
//
//  Created by Vitaliy on 04.10.2023.
//

import Foundation

final class GifDetailViewViewModel {
    
    private let gif: GifDataType
    
    private var requestUrl: URL? {
        return URL(string: gif.images.original.url)
    }
    
    var shareUrl: String {
        return gif.url
    }

    var title: String {
        gif.title
    }

    // MARK: - Init

    init(gif: GifDataType) {
        self.gif = gif
    }
    
    public func fetchImage(completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = requestUrl else {
            return
        }
        ImageLoader.shared.downloadImage(url, completion: completion)
    }
}
