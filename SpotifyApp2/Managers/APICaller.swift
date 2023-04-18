//
//  APICaller.swift
//  SpotifyApp2
//
//  Created by Ilona Punya on 8.04.23.
//

import Foundation

struct APICaller {
    static let shared = APICaller()
    
    struct Constants {
        static let baseAPIURL = "api.spotify.com"
        static let limit = "?limit="
    }
    
    private func createRequest(urlPath: String, queryItems: [URLQueryItem], httpMethod: HTTPMethod) -> URLRequest? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = Constants.baseAPIURL
        components.path = urlPath
        components.queryItems = queryItems
        
        guard let url = components.url else { return nil }
        var urlRequest = URLRequest(url: url)
        
        let semaphore = DispatchSemaphore(value: 0)
        AuthenticationManager.shared.getValidToken { token in
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            semaphore.signal()
        }
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = httpMethod.rawValue
        
        semaphore.wait()
        return urlRequest
    }
    
    //MARK: --POST
    
    func saveTrackWith(_ trackId: String, to playlistId: String, completion: @escaping (Bool) -> Void) {
        let queryItems = [
            URLQueryItem(name: "uris", value: "spotify:track:\(trackId)")
        ]
        guard let urlRequest = createRequest(urlPath: "/v1/playlists/\(playlistId)/tracks", queryItems: queryItems, httpMethod: .POST) else { return }
        performPostTask(urlRequest, responseString: "snapshot_id", completion: completion)
    }
    
    func createPlaylistWith(_ name: String, userID: String, completion: @escaping (Bool) -> Void) {
        guard var urlRequest = createRequest(urlPath: "/v1/users/\(userID)/playlists", queryItems: [], httpMethod: .POST) else { return }
        let json = [
            "name": name
        ]
        urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed)
        performTaskWithCode(urlRequest: urlRequest, okCode: 201, completion: completion)
    }
    
    func performPostTask(_ urlRequest: URLRequest, responseString: String, completion: @escaping (Bool) -> Void) {
        let task = URLSession.shared.dataTask(with: urlRequest, completionHandler: { data, _, error in
            guard let data = data, error == nil else {
                completion(false)
                return
            }
            do {
                let result = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                guard let response = result as? [String: Any], response[responseString] as? String != nil else {
                    completion(false)
                    return
                }
                completion(true)
            } catch {
                completion(false)
            }
            
        })
        task.resume()
    }
    
    //MARK: --PUT

    func saveArtistWith(_ id: String, completion: @escaping (Bool) -> Void) {
        let queryItems = [
            URLQueryItem(name: "type", value: "artist"),
            URLQueryItem(name: "ids", value: id)
        ]
        
        guard let urlRequest = createRequest(urlPath: "/v1/me/following", queryItems: queryItems, httpMethod: .PUT) else { return }
        performTaskWithCode(urlRequest: urlRequest, okCode: 204, completion: completion)
    }

    //MARK: --MANIPULATION
    
    func manipulateAlbum(_ id: String, method httpMethod: HTTPMethod, completion: @escaping (Bool) -> Void) {
        let queryItems = [
            URLQueryItem(name: "ids", value: id)
        ]
        
        guard let urlRequest = createRequest(urlPath: "/v1/me/albums", queryItems: queryItems, httpMethod: httpMethod) else {
            completion(false)
            return
        }
        performTaskWithCode(urlRequest: urlRequest, okCode: 200, completion: completion)
    }
    
    func manipulatePlaylist(_ id: String, method httpMethod: HTTPMethod, completion: @escaping (Bool) -> Void) {
        guard let urlRequest = createRequest(urlPath: "/v1/playlists/\(id)/followers", queryItems: [], httpMethod: httpMethod) else { return }
        performTaskWithCode(urlRequest: urlRequest, okCode: 200, completion: completion)
    }
    
    private func performTaskWithCode(urlRequest: URLRequest, okCode: Int, completion: @escaping (Bool) -> Void) {
        let task = URLSession.shared.dataTask(with: urlRequest, completionHandler: { _, response, error in
            guard error == nil, let code = (response as? HTTPURLResponse)?.statusCode else {
                completion(false)
                return
            }
            completion(code==okCode)
        })
        task.resume()
    }
    
    //MARK: --GET
    
    func getAlbumInfoById(_ id: String, completion: @escaping (Result<Album, Error>) -> Void) {
        guard let urlRequest = createRequest(urlPath: "/v1/albums/\(id)", queryItems: [], httpMethod: .GET) else {
            completion(.failure(APIError.invalidURL))
            return
        }
        performGetTask(urlRequest: urlRequest, completion: completion)
    }
    
    func getPlaylistsByCategoryId(_ categoryId: String, completion: @escaping (Result<FeaturedPlaylistsResponse, Error>) -> Void) {
        let queryItems = [
            URLQueryItem(name: "limit", value: "40")
        ]
        
        guard let urlRequest = createRequest(urlPath: "/v1/browse/categories/\(categoryId)/playlists", queryItems: queryItems, httpMethod: .GET) else {
            completion(.failure(APIError.invalidURL))
            return
        }
        performGetTask(urlRequest: urlRequest, completion: completion)
    }
    
    func getPlaylistInfoById(_ id: String, completion: @escaping (Result<PlaylistDetailsResponse, Error>) -> Void) {
        guard let urlRequest = createRequest(urlPath: "/v1/playlists/\(id)", queryItems: [], httpMethod: .GET) else {
            completion(.failure(APIError.invalidURL))
            return
        }
        performGetTask(urlRequest: urlRequest, completion: completion)
    }
    
    func getCategories(completion: @escaping (Result<CategoriesResponse, Error>) -> Void) {
        let queryItems = [
            URLQueryItem(name: "limit", value: "50")
        ]
        
        guard let urlRequest = createRequest(urlPath: "/v1/browse/categories", queryItems: queryItems, httpMethod: .GET) else {
            completion(.failure(APIError.invalidURL))
            return
        }
        performGetTask(urlRequest: urlRequest, completion: completion)
    }
    
    func getSearchResult(query: String, completion: @escaping (Result<SearchResponse, Error>) -> Void) {
        let queryItems = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "type", value: "album,artist,playlist,track"),
            URLQueryItem(name: "limit", value: "8")
        ]
        
        guard let urlRequest = createRequest(urlPath: "/v1/search", queryItems: queryItems, httpMethod: .GET) else {
            completion(.failure(APIError.invalidURL))
            return
        }
        performGetTask(urlRequest: urlRequest, completion: completion)
    }
    
    func getUserProfile(completion: @escaping (Result<UserProfile, Error>) -> Void) {
        guard let urlRequest = createRequest(urlPath: "/v1/me", queryItems: [], httpMethod: .GET) else {
            completion(.failure(APIError.invalidURL))
            return
        }
        performGetTask(urlRequest: urlRequest, completion: completion)
    }
    
    func getUsersAlbums(completion: @escaping (Result<UserAlbumsResponse, Error>) -> Void) {
        let queryItems = [
            URLQueryItem(name: "limit", value: "50")
        ]
        
        guard let urlRequest = createRequest(urlPath: "/v1/me/albums", queryItems: queryItems, httpMethod: .GET) else {
            completion(.failure(APIError.invalidURL))
            return
        }
        performGetTask(urlRequest: urlRequest, completion: completion)
    }
    
    func getUsersPlaylists(completion: @escaping (Result<PlaylistResponse, Error>) -> Void) {
        let queryItems = [
            URLQueryItem(name: "limit", value: "50")
        ]
        
        guard let urlRequest = createRequest(urlPath: "/v1/me/playlists", queryItems: queryItems, httpMethod: .GET) else {
            completion(.failure(APIError.invalidURL))
            return
        }
        performGetTask(urlRequest: urlRequest, completion: completion)
    }
    
    func getUsersFollowedArtists(completion: @escaping (Result<UserFollowingResponse, Error>) -> Void) {
        let queryItems = [
            URLQueryItem(name: "type", value: "artist"),
            URLQueryItem(name: "limit", value: "50")
        ]
        
        guard let urlRequest = createRequest(urlPath: "/v1/me/following", queryItems: queryItems, httpMethod: .GET) else {
            completion(.failure(APIError.invalidURL))
            return
        }
        performGetTask(urlRequest: urlRequest, completion: completion)
    }
    
    func getNewReleases(completion: @escaping (Result<NewReleasesResponse, Error>) -> Void) {
        let queryItems = [
            URLQueryItem(name: "country", value: "GB"),
            URLQueryItem(name: "limit", value: "20")
        ]
        
        guard let urlRequest = createRequest(urlPath: "/v1/browse/new-releases", queryItems: queryItems, httpMethod: .GET) else {
            completion(.failure(APIError.invalidURL))
            return
        }
        performGetTask(urlRequest: urlRequest, completion: completion)
    }
    
    func getFeaturedPlaylists(completion: @escaping (Result<FeaturedPlaylistsResponse, Error>) -> Void) {
        let queryItems = [
            URLQueryItem(name: "limit", value: "20")
        ]
        
        guard let urlRequest = createRequest(urlPath: "/v1/browse/featured-playlists", queryItems: queryItems, httpMethod: .GET) else {
            completion(.failure(APIError.invalidURL))
            return
        }
        performGetTask(urlRequest: urlRequest, completion: completion)
    }
    
    func getUsersTopTracks(for term: String, completion: @escaping (Result<TrackResponse, Error>) -> Void) {
        let queryItems = [
            URLQueryItem(name: "time_range", value: term),
            URLQueryItem(name: "limit", value: "50")
        ]
        
        guard let urlRequest = createRequest(urlPath: "/v1/me/top/tracks", queryItems: queryItems, httpMethod: .GET) else {
            completion(.failure(APIError.invalidURL))
            return
        }
        performGetTask(urlRequest: urlRequest, completion: completion)
    }
    
    private func performGetTask<T: Codable>(urlRequest: URLRequest, completion: @escaping (Result<T, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: urlRequest) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(APIError.failedToGetData))
                return
            }
            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    //MARK: --ENUMs
    
    enum APIError: Error {
        case invalidURL
        case failedToGetData
    }
    
    enum HTTPMethod: String {
        case GET
        case PUT
        case POST
        case DELETE
    }
}
