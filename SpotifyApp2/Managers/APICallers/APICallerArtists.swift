//
//  APICallerArtists.swift
//  SpotifyApp2
//
//  Created by Ilona Punya on 20.04.23.
//

import Foundation

struct APICallerArtists {
    static let Shared = APICallerArtists()
    
    //MARK: --PUT
    func SaveArtistWith(_ id: String, completion: @escaping (Bool) -> Void) {
        let queryItems = [
            URLQueryItem(name: "type", value: "artist"),
            URLQueryItem(name: "ids", value: id)
        ]
        
        guard let urlRequest = APICaller.Shared.CreateRequest(urlPath: "/v1/me/following", queryItems: queryItems, httpMethod: .PUT) else { return }
        APICaller.Shared.PerformTaskWithCode(urlRequest: urlRequest, okCode: 204, completion: completion)
    }
    
    //MARK: --GET
    func GetUsersFollowedArtists(completion: @escaping (Result<UserFollowingResponse, Error>) -> Void) {
        let queryItems = [
            URLQueryItem(name: "type", value: "artist"),
            URLQueryItem(name: "limit", value: "50")
        ]
        
        guard let urlRequest = APICaller.Shared.CreateRequest(urlPath: "/v1/me/following", queryItems: queryItems, httpMethod: .GET) else {
            completion(.failure(APICaller.APIError.invalidURL))
            return
        }
        APICaller.Shared.PerformGetTask(urlRequest: urlRequest, completion: completion)
    }
}
