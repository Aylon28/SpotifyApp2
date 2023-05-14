//
//  APICallerAlbums.swift
//  SpotifyApp2
//
//  Created by Ilona Punya on 20.04.23.
//

import Foundation

struct APICallerAlbums {
    static let Shared = APICallerAlbums()
    
    //MARK: --MANIPULATION
    func ManipulateAlbum(_ id: String, method httpMethod: APICaller.HTTPMethod, completion: @escaping (Bool) -> Void) {
        let queryItems = [
            URLQueryItem(name: "ids", value: id)
        ]
        
        guard let urlRequest = APICaller.Shared.CreateRequest(urlPath: "/v1/me/albums", queryItems: queryItems, httpMethod: httpMethod) else {
            completion(false)
            return
        }
        APICaller.Shared.PerformTaskWithCode(urlRequest: urlRequest, okCode: 200, completion: completion)
    }
    
    //MARK: --GET
    func GetAlbumInfoById(_ id: String, completion: @escaping (Result<Album, Error>) -> Void) {
        guard let urlRequest = APICaller.Shared.CreateRequest(urlPath: "/v1/albums/\(id)", queryItems: [], httpMethod: .GET) else {
            completion(.failure(APICaller.APIError.invalidURL))
            return
        }
        APICaller.Shared.PerformGetTask(urlRequest: urlRequest, completion: completion)
    }
    
    func GetNewReleases(completion: @escaping (Result<NewReleasesResponse, Error>) -> Void) {
        let queryItems = [
            URLQueryItem(name: "country", value: "GB"),
            URLQueryItem(name: "limit", value: "20")
        ]
        
        guard let urlRequest = APICaller.Shared.CreateRequest(urlPath: "/v1/browse/new-releases", queryItems: queryItems, httpMethod: .GET) else {
            completion(.failure(APICaller.APIError.invalidURL))
            return
        }
        APICaller.Shared.PerformGetTask(urlRequest: urlRequest, completion: completion)
    }
    
    func GetUsersAlbums(completion: @escaping (Result<UserAlbumsResponse, Error>) -> Void) {
        let queryItems = [
            URLQueryItem(name: "limit", value: "50")
        ]
        
        guard let urlRequest = APICaller.Shared.CreateRequest(urlPath: "/v1/me/albums", queryItems: queryItems, httpMethod: .GET) else {
            completion(.failure(APICaller.APIError.invalidURL))
            return
        }
        APICaller.Shared.PerformGetTask(urlRequest: urlRequest, completion: completion)
    }
}
