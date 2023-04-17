//
//  SearchViewModel.swift
//  SpotifyApp2
//
//  Created by Ilona Punya on 16.04.23.
//

import Foundation

class SearchViewModel {
    var categories: Observable<[Category]?> = Observable(nil)
    
    var categoriesCount: Int {
        return categories.value?.count ?? 0
    }
    
    func getCategoryCollectionViewCellViewModel(_ number: Int) -> CategoryCollectionViewCellViewModel {
        let category = categories.value?[number]
        return CategoryCollectionViewCellViewModel(categoryTitle: category?.name ?? "", coverImageURL: URL(string: category?.icons.first?.url ?? ""))
    }
    
    func fetchCategories() {
        APICaller.shared.getCategories { [weak self] result in
            switch result {
            case .success(let categoriesResponse):
                self?.categories.value = categoriesResponse.categories.items
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func searchButtonClicked(_ query: String, completion: @escaping ([SearchResult]) -> Void) {
        APICaller.shared.getSearchResult(query: query) { result in
            switch result {
            case .success(let searchResponse):
                var searchResults = [SearchResult]()
                searchResults.append(contentsOf: searchResponse.artists.items.compactMap { SearchResult.artist(model: $0) })
                searchResults.append(contentsOf: searchResponse.tracks.items.compactMap { SearchResult.track(model: $0) })
                searchResults.append(contentsOf: searchResponse.playlists.items.compactMap { SearchResult.playlist(model: $0) })
                searchResults.append(contentsOf: searchResponse.albums.items.compactMap { SearchResult.album(model: $0) })
                completion(searchResults)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
