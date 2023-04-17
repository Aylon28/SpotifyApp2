//
//  HomeViewModel.swift
//  SpotifyApp2
//
//  Created by Ilona Punya on 17.04.23.
//

import Foundation

enum BrowseSectionType {
    case newReleases(viewModel: [Album])
    case featuredPlaylists(viewModel: [Playlist])
    case topTracks(viewModel: [Track])
    case allTimeFavourites(viewModel: [Track])
    
    var sectionTitle: String {
        switch self {
        case .newReleases:
            return "New Releases for you"
        case .featuredPlaylists:
            return "Featured Playlists"
        case .topTracks:
            return "Your last month favouites"
        case .allTimeFavourites:
            return "Your all time favourite songs"
        }
    }
}

class HomeViewModel {
    var sections: Observable<[BrowseSectionType]> = Observable([BrowseSectionType]())
    
    func getSectionsCount() -> Int {
        return sections.value.count
    }
    
    func getSectionItemsCount(_ section: Int) -> Int {
        let type = sections.value[section]
        
        switch type {
        case .newReleases:
            return 6
        case .featuredPlaylists(let playlists):
            return playlists.count
        case .topTracks(let tracks):
            return tracks.count
        case .allTimeFavourites(let tracks):
            return tracks.count
        }
    }
    
    func trackTapped(_ indexPath: IndexPath, completion: @escaping (Bool) -> Void) {
        let type = sections.value[indexPath.section]
        switch type {
        case .topTracks(let tracks):
            PlaybackPresenter.shared.playSong(track: tracks[indexPath.row]) { completion($0) }
        case .allTimeFavourites(let tracks):
            PlaybackPresenter.shared.playSong(track: tracks[indexPath.row]) { completion($0) }
        default:
            completion(false)
        }

    }
    
    func fetchData() {
        var newReleases: NewReleasesResponse?
        var featuredPlaylists: FeaturedPlaylistsResponse?
        var topTracks: TrackResponse?
        var allTimeFavouriteTracks: TrackResponse?
        
        let group = DispatchGroup()
        group.enter()
        group.enter()
        group.enter()
        group.enter()
        
        APICaller.shared.getNewReleases { result in
            switch result {
            case .success(let newReleasesResponse):
                newReleases = newReleasesResponse
                group.leave()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        APICaller.shared.getFeaturedPlaylists { result in
            switch result {
            case .success(let featuredPlaylistsResponse):
                featuredPlaylists = featuredPlaylistsResponse
                group.leave()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        APICaller.shared.getUsersTopTracks(for: "short_term") { result in
            switch result {
            case .success(let topTracksResponse):
                topTracks = topTracksResponse
                group.leave()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        APICaller.shared.getUsersTopTracks(for: "long_term") { result in
            switch result {
            case .success(let allTimeFavouriteTracksResponse):
                allTimeFavouriteTracks = allTimeFavouriteTracksResponse
                group.leave()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    
        group.notify(queue: .main) { [weak self] in
            guard let albums = newReleases?.albums.items,
                  let playlists = featuredPlaylists?.playlists.items,
                  let tracks = topTracks?.items,
                  let allTimeTracks = allTimeFavouriteTracks?.items else { return }
            self?.configureModels(newReleasedAlbums: albums, featuredPlaylists: playlists, topTracks: tracks, allTimeTracks: allTimeTracks)
        }
    }
    
    private func configureModels(newReleasedAlbums: [Album], featuredPlaylists: [Playlist], topTracks: [Track], allTimeTracks: [Track]) {
        sections.value = []
        sections.value.append(.newReleases(viewModel: newReleasedAlbums.shuffled()))
        sections.value.append(.featuredPlaylists(viewModel: featuredPlaylists.shuffled()))
        sections.value.append(.topTracks(viewModel: topTracks.shuffled()))
        sections.value.append(.allTimeFavourites(viewModel: allTimeTracks))
    }
}
