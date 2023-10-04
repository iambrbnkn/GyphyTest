//
//  GifDataType.swift
//  GiphyTestApp
//
//  Created by Vitaliy on 04.10.2023.
//

import Foundation

struct GifDataType: Codable {
    let id: String
    let url: String
    let title: String
    let images: Sizes
}

struct Sizes: Codable {
    let original, fixedHeight, fixedWidth: gifURL

    enum CodingKeys: String, CodingKey {
        case original
        case fixedHeight = "fixed_height"
        case fixedWidth = "fixed_width"
    }
}

struct gifURL: Codable {
    let url: String
}
