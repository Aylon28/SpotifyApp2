//
//  SettingsViewModel.swift
//  SpotifyApp2
//
//  Created by Ilona Punya on 16.04.23.
//

import Foundation

class SettingsViewModel {
    var settings: Observable<[Section]> = Observable([Section]())
    
    var settingsCount: Int {
        return settings.value.count
    }
    
    func getTitleForHeader(_ section: Int) -> String {
        return settings.value[section].title
    }
    
    func getSettingsInSectionCount(_ number: Int) -> Int {
        return settings.value[number].options.count
    }
    
    func getDefaultTableViewSystemImageCellViewModel(_ indexPath: IndexPath) -> DefaultTableViewSystemImageCellViewModel {
        let setting = settings.value[indexPath.section].options[indexPath.row]
        return DefaultTableViewSystemImageCellViewModel(title: setting.title, coverImage: setting.iconSystemName)
    }
    
    func settingTapped(_ indexPath: IndexPath) {
        settings.value[indexPath.section].options[indexPath.row].handler()
    }
    
    func signOut(completion: @escaping (Bool) -> Void) {
        AuthenticationManager.shared.signOut() { result in
            completion(result)
        }
    }
}
