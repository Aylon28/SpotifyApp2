//
//  ProfileViewModel.swift
//  SpotifyApp2
//
//  Created by Ilona Punya on 16.04.23.
//

import Foundation

class ProfileViewModel {
    var userInfoResponse: UserProfile?
    var userInfo: Observable<[String: [String]]> = Observable([String: [String]]())
    
    struct Constants {
        static let values = "values"
        static let titles = "titles"
    }
    
    var itemsCount: Int {
        return userInfo.value[Constants.values]?.count ?? 0
    }
    
    func getUserProfileTableViewCellViewModel(_ number: Int) -> UserProfileTableViewCellViewModel {
        return UserProfileTableViewCellViewModel(title: userInfo.value[Constants.titles]![number], value: userInfo.value[Constants.values]![number])
    }
    
    func fetchUserData(completion: @escaping (Bool) -> Void) {
        APICaller.shared.getUserProfile { [weak self] result in
            switch result {
            case .success(let userInfoResponse):
                self?.userInfoResponse = userInfoResponse
                self?.configureModels(userInfoResponse)
                completion(true)
            case .failure(let error):
                print(error.localizedDescription)
                completion(false)
            }
        }
    }
    
    private func configureModels(_ userInfo: UserProfile) {
        self.userInfo.value[Constants.titles] = [
            "Name", "E-mail", "Country", "Account type", "Account id", "Followers"
        ]
        self.userInfo.value[Constants.values] = [
            userInfo.display_name, userInfo.email, userInfo.country, userInfo.product, userInfo.id, "\(userInfo.followers.total)"
        ]
    }
    
}
