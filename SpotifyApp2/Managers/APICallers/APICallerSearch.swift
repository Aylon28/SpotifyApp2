//
//  APICallerSearch.swift
//  SpotifyApp2
//
//  Created by Ilona Punya on 20.04.23.
//

import Foundation

struct APICallerSearch {
    static let Shared = APICallerSearch()
    
    //MARK: --GET
    func GetCategories(completion: @escaping (Result<CategoriesResponse, Error>) -> Void) {
        let queryItems = [
            URLQueryItem(name: "limit", value: "50")
        ]
        
        guard let urlRequest = APICaller.Shared.CreateRequest(urlPath: "/v1/browse/categories", queryItems: queryItems, httpMethod: .GET) else {
            completion(.failure(APICaller.APIError.invalidURL))
            return
        }
        APICaller.Shared.PerformGetTask(urlRequest: urlRequest, completion: completion)
    }

    func GetSearchResult(query: String, completion: @escaping (Result<SearchResponse, Error>) -> Void) {
        let queryItems = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "type", value: "album,artist,playlist,track"),
            URLQueryItem(name: "limit", value: "8")
        ]
        
        guard let urlRequest = APICaller.Shared.CreateRequest(urlPath: "/v1/search", queryItems: queryItems, httpMethod: .GET) else {
            completion(.failure(APICaller.APIError.invalidURL))
            return
        }
        APICaller.Shared.PerformGetTask(urlRequest: urlRequest, completion: completion)
    }
}

