//
//  APICallerPlaylists.swift
//  SpotifyApp2
//
//  Created by Ilona Punya on 20.04.23.
//

import Foundation

struct APICallerPlaylists {
    static let Shared = APICallerPlaylists()

    //MARK: --POST
    func CreatePlaylistWith(_ name: String, userID: String, completion: @escaping (Bool) -> Void) {
        guard var urlRequest = APICaller.Shared.CreateRequest(urlPath: "/v1/users/\(userID)/playlists", queryItems: [], httpMethod: .POST) else { return }
        let json = [
            "name": name
        ]
        urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed)
        APICaller.Shared.PerformTaskWithCode(urlRequest: urlRequest, okCode: 201, completion: completion)
    }
    
    //MARK: --MANIPULATION
    func ManipulatePlaylist(_ id: String, method httpMethod: APICaller.HTTPMethod, completion: @escaping (Bool) -> Void) {
        guard let urlRequest = APICaller.Shared.CreateRequest(urlPath: "/v1/playlists/\(id)/followers", queryItems: [], httpMethod: httpMethod) else {
            completion(false)
            return
        }
        APICaller.Shared.PerformTaskWithCode(urlRequest: urlRequest, okCode: 200, completion: completion)
    }
    
    //MARK: --GET
    func GetPlaylistsByCategoryId(_ categoryId: String, completion: @escaping (Result<FeaturedPlaylistsResponse, Error>) -> Void) {
        let queryItems = [
            URLQueryItem(name: "limit", value: "40")
        ]
        
        guard let urlRequest = APICaller.Shared.CreateRequest(urlPath: "/v1/browse/categories/\(categoryId)/playlists", queryItems: queryItems, httpMethod: .GET) else {
            completion(.failure(APICaller.APIError.invalidURL))
            return
        }
        APICaller.Shared.PerformGetTask(urlRequest: urlRequest, completion: completion)
    }
    
    func GetPlaylistInfoById(_ id: String, completion: @escaping (Result<PlaylistDetailsResponse, Error>) -> Void) {
        guard let urlRequest = APICaller.Shared.CreateRequest(urlPath: "/v1/playlists/\(id)", queryItems: [], httpMethod: .GET) else {
            completion(.failure(APICaller.APIError.invalidURL))
            return
        }
        APICaller.Shared.PerformGetTask(urlRequest: urlRequest, completion: completion)
    }
    
    func GetUsersPlaylists(completion: @escaping (Result<PlaylistResponse, Error>) -> Void) {
        let queryItems = [
            URLQueryItem(name: "limit", value: "50")
        ]
        
        guard let urlRequest = APICaller.Shared.CreateRequest(urlPath: "/v1/me/playlists", queryItems: queryItems, httpMethod: .GET) else {
            completion(.failure(APICaller.APIError.invalidURL))
            return
        }
        APICaller.Shared.PerformGetTask(urlRequest: urlRequest, completion: completion)
    }
    
    func GetFeaturedPlaylists(completion: @escaping (Result<FeaturedPlaylistsResponse, Error>) -> Void) {
        let queryItems = [
            URLQueryItem(name: "limit", value: "20")
        ]
        
        guard let urlRequest = APICaller.Shared.CreateRequest(urlPath: "/v1/browse/featured-playlists", queryItems: queryItems, httpMethod: .GET) else {
            completion(.failure(APICaller.APIError.invalidURL))
            return
        }
        APICaller.Shared.PerformGetTask(urlRequest: urlRequest, completion: completion)
    }
}
