//
//  APICaller.swift
//  SpotifyApp2
//
//  Created by Ilona Punya on 8.04.23.
//

import Foundation

struct APICaller {
    static let Shared = APICaller()
    
    private struct Constants {
        static let baseAPIURL = "api.spotify.com"
        static let limit = "?limit="
    }
    
    func CreateRequest(urlPath: String, queryItems: [URLQueryItem], httpMethod: HTTPMethod) -> URLRequest? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = Constants.baseAPIURL
        components.path = urlPath
        components.queryItems = queryItems
        
        guard let url = components.url else { return nil }
        var urlRequest = URLRequest(url: url)
        
        let semaphore = DispatchSemaphore(value: 0)
        AuthenticationManager.Shared.GetValidToken { token in
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            semaphore.signal()
        }
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = httpMethod.rawValue
        
        semaphore.wait()
        return urlRequest
    }

    func PerformPostTask(_ urlRequest: URLRequest, responseString: String, completion: @escaping (Bool) -> Void) {
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
    
    func PerformTaskWithCode(urlRequest: URLRequest, okCode: Int, completion: @escaping (Bool) -> Void) {
        let task = URLSession.shared.dataTask(with: urlRequest, completionHandler: { _, response, error in
            guard error == nil, let code = (response as? HTTPURLResponse)?.statusCode else {
                completion(false)
                return
            }
            completion(code==okCode)
        })
        task.resume()
    }
    
    func PerformGetTask<T: Codable>(urlRequest: URLRequest, completion: @escaping (Result<T, Error>) -> Void) {
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
