//
//  AuthenticationManager.swift
//  SpotifyApp2
//
//  Created by Ilona Punya on 6.04.23.
//

import Foundation

struct AuthenticationManager {
    static let shared = AuthenticationManager()
    
    struct Constants {
        static let authHost = "accounts.spotify.com"
        static let clientID = "e22e9b9dede74131843b7b4b8113f32e"
        static let clientSecret = "21540e2b94294aa5b8c1b0647eafdc63"
        static let redirectURI = "https://www.twitter.com"
        static let scope = "user-read-private%20user-read-email%20user-library-read%20user-follow-read%20user-top-read%20user-library-modify%20user-library-modify%20playlist-modify-public%20playlist-modify-private%20user-follow-modify"
        
        enum UserDefaultsKeys: String {
            case accessToken
            case expireDate
            case refreshToken
        }
    }
    
    var accessToken: String? {
        return UserDefaults.standard.string(forKey: Constants.UserDefaultsKeys.accessToken.rawValue)
    }
    
    var refreshToken: String? {
        return UserDefaults.standard.string(forKey: Constants.UserDefaultsKeys.refreshToken.rawValue)
    }
    
    var tokenExpirationDate: Date? {
        return UserDefaults.standard.object(forKey: Constants.UserDefaultsKeys.expireDate.rawValue) as? Date
    }
    
    var isSignedIn: Bool {
        return accessToken != nil
    }
    
    var shouldRefreshToken: Bool {
        guard let expirationDate = tokenExpirationDate else { return false }
        let currentDate = Date()
        let bufferTime: TimeInterval = 500
        return expirationDate <= currentDate.addingTimeInterval(bufferTime)
    }
    
    func getValidToken(completion: @escaping (String) -> Void) {
        if shouldRefreshToken {
            refreshToken { result in
                if result {
                    guard let token = accessToken else { return }
                    completion(token)
                }
            }
        } else {
            guard let token = accessToken else { return }
            completion(token)
        }
    }
    
    private func getURLFromComponents(path: String, queryItems: [URLQueryItem]) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = Constants.authHost
        components.path = path
        
        components.queryItems = queryItems
        return components.url
    }
    
    func getAccessCodeURL() -> URLRequest? {
        let queryItems = [
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "client_id", value: Constants.clientID),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "scope", value: Constants.scope)
        ]
        guard let url = getURLFromComponents(path: "/authorize", queryItems: queryItems) else { return nil }
        return URLRequest(url: url)
    }
    
    private func performTaskForAccessToken(queryItems: [URLQueryItem], completion: @escaping (Bool) -> Void) {
        guard let url = getURLFromComponents(path: "/api/token", queryItems: queryItems) else { return }
        
        var urlRequest = URLRequest(url: url)
        let toBase64String = "\(Constants.clientID):\(Constants.clientSecret)".toBase64()
        urlRequest.setValue("Basic \(toBase64String)", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, _, error in
            guard let data = data, error == nil else {
                print(error!.localizedDescription)
                completion(false)
                return
            }
            do {
                let result = try JSONDecoder().decode(AuthenticationResponse.self, from: data)
                saveAuthResponse(result)
                completion(true)
            } catch {
                completion(false)
            }
        }
        task.resume()
    }
    
    func changeCodeForToken(code: String, completion: @escaping (Bool) -> Void) {
        let queryItems = [
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        
        performTaskForAccessToken(queryItems: queryItems) { result in
            completion(result)
        }
    }
    
    func refreshToken(completion: ((Bool) -> Void)?) {
        if shouldRefreshToken {
            guard let refreshToken = refreshToken else { return }
            let queryItems = [
                URLQueryItem(name: "refresh_token", value: refreshToken),
                URLQueryItem(name: "grant_type", value: "refresh_token")
            ]
            
            performTaskForAccessToken(queryItems: queryItems) { result in
                completion?(result)
            }
        }
    }
    
    func saveAuthResponse(_ authInfo: AuthenticationResponse) {
        UserDefaults.standard.setValue(authInfo.access_token, forKey: Constants.UserDefaultsKeys.accessToken.rawValue)
        if authInfo.refresh_token != nil {
            UserDefaults.standard.setValue(authInfo.refresh_token, forKey: Constants.UserDefaultsKeys.refreshToken.rawValue)
        }
        let expireDate = Date().addingTimeInterval(TimeInterval(authInfo.expires_in))
        UserDefaults.standard.setValue(expireDate, forKey: Constants.UserDefaultsKeys.expireDate.rawValue)
    }
    
    func signOut(completion: @escaping (Bool) -> Void) {
        UserDefaults.standard.setValue(nil, forKey: Constants.UserDefaultsKeys.accessToken.rawValue)
        UserDefaults.standard.setValue(nil, forKey: Constants.UserDefaultsKeys.refreshToken.rawValue)
        UserDefaults.standard.setValue(nil, forKey: Constants.UserDefaultsKeys.expireDate.rawValue)
        completion(true)
    }
}
