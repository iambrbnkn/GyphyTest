//
//  TrendingModel.swift
//  GiphyTestApp
//
//  Created by Vitaliy on 04.10.2023.
//

import Foundation

// MARK: - TrendingModel
struct TrendingModel: Codable {
    let data: [GifDataType]
    let pagination: Pagination
}

// MARK: - Pagination
struct Pagination: Codable {
    let totalCount: Int

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
    }
}
