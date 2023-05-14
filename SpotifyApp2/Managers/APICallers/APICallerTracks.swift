//
//  APICallerTracks.swift
//  SpotifyApp2
//
//  Created by Ilona Punya on 20.04.23.
//

import Foundation

struct APICallerTracks {
    static let Shared = APICallerTracks()
    
    //MARK: --POST
    func SaveTrackWith(_ trackId: String, to playlistId: String, completion: @escaping (Bool) -> Void) {
        let queryItems = [
            URLQueryItem(name: "uris", value: "spotify:track:\(trackId)")
        ]
        guard let urlRequest = APICaller.Shared.CreateRequest(urlPath: "/v1/playlists/\(playlistId)/tracks", queryItems: queryItems, httpMethod: .POST) else {
            completion(false)
            return
        }
        APICaller.Shared.PerformPostTask(urlRequest, responseString: "snapshot_id", completion: completion)
    }
    
    //MARK: --GET
    func GetUsersTopTracks(for term: String, completion: @escaping (Result<TrackResponse, Error>) -> Void) {
        let queryItems = [
            URLQueryItem(name: "time_range", value: term),
            URLQueryItem(name: "limit", value: "50")
        ]
        
        guard let urlRequest = APICaller.Shared.CreateRequest(urlPath: "/v1/me/top/tracks", queryItems: queryItems, httpMethod: .GET) else {
            completion(.failure(APICaller.APIError.invalidURL))
            return
        }
        APICaller.Shared.PerformGetTask(urlRequest: urlRequest, completion: completion)
    }
}
