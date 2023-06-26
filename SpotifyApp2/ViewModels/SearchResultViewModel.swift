//
//  SearchResultViewModel.swift
//  SpotifyApp2
//
//  Created by Ilona Punya on 16.04.23.
//

import Foundation

enum SearchResult {
    case artist(model: Artist)
    case track(model: Track)
    case playlist(model: Playlist)
    case album(model: Album)
}

struct SearchSection {
    let sectionTitle: String
    let sectionContent: [SearchResult]
}

protocol SearchResultViewModelDelegate: AnyObject {
    func didTapResult(_ result: SearchResult)
}

class SearchResultViewModel {
    var delegate: SearchResultViewModelDelegate?
    var sections: Observable<[SearchSection]?> = Observable(nil)
    
    var sectionsCount: Int {
        return sections.value?.count ?? 0
    }
    
    func sectionContentCount(_ section: Int) -> Int {
        return sections.value?[section].sectionContent.count ?? 0
    }
    
    func getSectionContent(_ indexPath: IndexPath) -> SearchResult? {
        return sections.value?[indexPath.section].sectionContent[indexPath.row]
    }
    
    func getSectionTitle(_ section: Int) -> String {
        return sections.value?[section].sectionTitle ?? ""
    }
    
    func getSubtitleTableViewCellViewModel(_ indexPath: IndexPath) -> SubtitleTableViewCellViewModel {
        if let content = getSectionContent(indexPath) {
            switch content {
            case .track(let track):
                return SubtitleTableViewCellViewModel(title: track.name, subtitle: track.artists.first?.name ?? "", coverImageURL: URL(string: track.album?.images.first?.url ?? ""))
            case .playlist(let playlist):
                return SubtitleTableViewCellViewModel(title: playlist.name, subtitle: playlist.owner.display_name, coverImageURL: URL(string: playlist.images.first?.url ?? ""))
            case .album(let album):
                return SubtitleTableViewCellViewModel(title: album.name, subtitle: album.artists.first?.name ?? "", coverImageURL: URL(string: album.images.first?.url ?? ""))
            default:
                break
            }
        }
        return SubtitleTableViewCellViewModel(title: "", subtitle: "", coverImageURL: nil)
    }
    
    func getDefaultTableViewCellViewModel(_ indexPath: IndexPath) -> DefaultTableViewCellViewModel {
        if let content = getSectionContent(indexPath) {
            switch content {
            case .artist(let artist):
                return DefaultTableViewCellViewModel(title: artist.name, coverImageURL: URL(string: artist.images?.first?.url ?? ""))
            default:
                break
            }
        }
        return DefaultTableViewCellViewModel(title: "", coverImageURL: nil)
    }
    
    func didTapTableViewRowAt(_ indexPath: IndexPath) {
        guard let result = sections.value?[indexPath.section].sectionContent[indexPath.row] else { return }
        delegate?.didTapResult(result)
    }
    
    func saveArtist(_ id: String) {
        APICallerArtists.Shared.SaveArtistWith(id) { [weak self] result in
            self?.hapticsResponse(result)
        }
    }
    
    func saveTrack(_ id: String, playlisId: String) {
        APICallerTracks.Shared.SaveTrackWith(id, to: playlisId) { [weak self] result in
            self?.hapticsResponse(result)
        }
    }
    
    func savePlaylist(_ id: String) {
        APICallerPlaylists.Shared.ManipulatePlaylist(id, method: .PUT) { [weak self] result in
            self?.hapticsResponse(result)
        }
    }
    
    func saveAlbum(_ id: String) {
        APICallerAlbums.Shared.ManipulateAlbum(id, method: .PUT) { [weak self] result in
            self?.hapticsResponse(result)
        }
    }
    
    private func hapticsResponse(_ result: Bool) {
        if result {
            HapticsManager.Shared.Vibrate(for: .success)
        } else {
            HapticsManager.Shared.Vibrate(for: .error)
        }
    }
    
    func filterResults(results: [SearchResult]) {
        let artists = results.filter {
            switch $0 {
            case .artist: return true
            default: return false
            }
        }
        
        let albums = results.filter {
            switch $0 {
            case .album: return true
            default: return false
            }
        }
        
        let tracks = results.filter {
            switch $0 {
            case .track: return true
            default: return false
            }
        }
        
        let playlists = results.filter {
            switch $0 {
            case .playlist: return true
            default: return false
            }
        }
        
        sections.value = [
            SearchSection(sectionTitle: "Songs", sectionContent: tracks),
            SearchSection(sectionTitle: "Artists", sectionContent: artists),
            SearchSection(sectionTitle: "Albums", sectionContent: albums),
            SearchSection(sectionTitle: "Playlists", sectionContent: playlists)
        ]
    }
}
