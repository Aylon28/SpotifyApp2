//
//  APICallerUser.swift
//  SpotifyApp2
//
//  Created by Ilona Punya on 20.04.23.
//

import Foundation

struct APICallerUser {
    static let Shared = APICallerUser()
    
    //MARK: --GET
    func GetUserProfile(completion: @escaping (Result<UserProfile, Error>) -> Void) {
        guard let urlRequest = APICaller.Shared.CreateRequest(urlPath: "/v1/me", queryItems: [], httpMethod: .GET) else {
            completion(.failure(APICaller.APIError.invalidURL))
            return
        }
        APICaller.Shared.PerformGetTask(urlRequest: urlRequest, completion: completion)
    }
}
