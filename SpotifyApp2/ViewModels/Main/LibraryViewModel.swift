//
//  LibraryViewModel.swift
//  SpotifyApp2
//
//  Created by Ilona Punya on 16.04.23.
//

import Foundation

class LibraryViewModel {
    var playlistSelectionHandler: ((String) -> Void)?

    var choosedSection: LibrarySection = .playlists
    var playlistsAreOwnedByUser: Bool = false

    var playlists: Observable<[Playlist]> = Observable([Playlist]())
    var albums: Observable<[Album]> = Observable([Album]())
    var artists: Observable<[Artist]> = Observable([Artist]())
    
    var rowsCount: Int {
        switch choosedSection {
        case .playlists:
            return playlists.value.count
        case .albums:
            return albums.value.count
        case .artists:
            return artists.value.count
        }
    }
    
    init(playlistsAreOwnedByUser: Bool) {
        self.playlistsAreOwnedByUser = playlistsAreOwnedByUser
    }
    
    func getArtistURL(_ number: Int) -> URL? {
        return URL(string: artists.value[number].external_urls?["spotify"] ?? "")
    }
    
    func segmentValueChanged(_ value: Int) {
        switch value {
        case 0:
            choosedSection = .playlists
            fetchPlaylists()
        case 1:
            choosedSection = .albums
            fetchAlbums()
        case 2:
            choosedSection = .artists
            fetchArtists()
        default:
            break
        }
    }
    
    func getSubtitleTableViewCellViewModel(_ number: Int) -> SubtitleTableViewCellViewModel {
        if choosedSection == .playlists {
            return SubtitleTableViewCellViewModel(title: playlists.value[number].name, subtitle: playlists.value[number].owner.display_name, coverImageURL: URL(string: playlists.value[number].images.first?.url ?? ""))
        }
        return SubtitleTableViewCellViewModel(title: albums.value[number].name, subtitle: albums.value[number].artists.first?.name ?? "", coverImageURL: URL(string: albums.value[number].images.first?.url ?? ""))
    }
    
    func getDefaultTableViewCellViewModel(_ number: Int) -> DefaultTableViewCellViewModel {
        return DefaultTableViewCellViewModel(title: artists.value[number].name, coverImageURL: URL(string: artists.value[number].images?.first?.url ?? ""))
    }
    
    func createPlaylistTapped(_ playlistName: String) {
        APICaller.shared.getUserProfile { [weak self] result in
            switch result {
            case .success(let userProfile):
                APICaller.shared.createPlaylistWith(playlistName, userID: userProfile.id) { result in
                    if result {
                        HapticsManager.shared.vibrate(for: .success)
                        self?.fetchPlaylists()
                    } else {
                        HapticsManager.shared.vibrate(for: .error)
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchData() {
        fetchAlbums()
        fetchArtists()
        fetchPlaylists()
    }
    
    func fetchAlbums() {
        APICaller.shared.getUsersAlbums { [weak self] result in
            switch result {
            case .success(let albumsResponse):
                var albums = [Album]()
                albumsResponse.items.forEach { item in
                    albums.append(item.album)
                }
                self?.albums.value = albums
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchPlaylists() {
        APICaller.shared.getUserProfile { result in
            switch result {
            case .success(let userProfile):
                APICaller.shared.getUsersPlaylists { [unowned self] result in
                    switch result {
                    case .success(let playlistsResponse):
                        if self.playlistsAreOwnedByUser {
                            self.playlists.value = playlistsResponse.items.filter { $0.owner.id == userProfile.id }
                        } else {
                            self.playlists.value = playlistsResponse.items
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchArtists() {
        APICaller.shared.getUsersFollowedArtists { [weak self] result in
            switch result {
            case .success(let followingResponse):
                self?.artists.value = followingResponse.artists.items
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    enum LibrarySection {
        case playlists
        case albums
        case artists
    }
}
