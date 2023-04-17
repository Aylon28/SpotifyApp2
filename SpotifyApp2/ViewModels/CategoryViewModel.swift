//
//  CategoryViewModel.swift
//  SpotifyApp2
//
//  Created by Ilona Punya on 16.04.23.
//

import Foundation

class CategoryViewModel {
    var category: Category?
    var categoryPlaylists: Observable<[Playlist]?> = Observable(nil)
    
    var playlistsCount: Int {
        return categoryPlaylists.value?.count ?? 0
    }
    
    var categoryName: String {
        return category?.name ?? ""
    }
    
    init(category: Category) {
        self.category = category
    }
    
    func getPlaylistByNumber(_ number: Int) -> Playlist? {
        return categoryPlaylists.value?[number]
    }
    
    func getPlaylistCoverCollectionViewCellViewModel(_ number: Int) -> PlaylistCoverCollectionViewCellViewModel {
        return PlaylistCoverCollectionViewCellViewModel(
            playlistName: categoryPlaylists.value?[number].name ?? "", ownerName: categoryPlaylists.value?[number].owner.display_name ?? "", coverURL: URL(string: categoryPlaylists.value?[number].images.first?.url ?? ""))
    }
    
    func fetchPlaylistsData() {
        guard let id = category?.id else { return }
        APICaller.shared.getPlaylistsByCategoryId(id) { [weak self] result in
            switch result {
            case .success(let playlists):
                self?.categoryPlaylists.value = playlists.playlists.items
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
