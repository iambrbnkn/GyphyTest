//
//  ApiService.swift
//  GiphyTestApp
//
//  Created by Vitaliy on 04.10.2023.
//

import Foundation

protocol ApiServiceProtocol {
    func execute(withOffset offset: Int, completion: @escaping(Result<TrendingModel, Error>) -> Void
    )
}

final class ApiService: ApiServiceProtocol {
    
    private let session = URLSession.shared
        
    private let apiKey = "qYFgJMc13LxEVBySTSmRmUZOyYbkJQi8"
    
    private let limit = "20"
 
    enum ApiServiceError: Error {
        case failedToCreateRequest
        case failedToGetData
        case invalidURL
        case invalidJSON
    }
    
    func execute(withOffset offset: Int,
        completion: @escaping(Result<TrendingModel, Error>) -> Void
    ) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.giphy.com"
        urlComponents.path = "/v1/gifs/trending"
        urlComponents.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "limit", value: limit),
            URLQueryItem(name: "offset", value: String(offset)),
            URLQueryItem(name: "rating", value: "g"),
            URLQueryItem(name: "bundle", value: "messaging_non_clips")
        ]
        
        guard let url = urlComponents.url else {
            completion(.failure(ApiServiceError.invalidURL))
            return
        }
        //TODO: - Delete this
        print(url)
        
        let task = session.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? ApiServiceError.failedToGetData))
                return
            }
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(TrendingModel.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
