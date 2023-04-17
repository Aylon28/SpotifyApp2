//
//  PlaylistViewModel.swift
//  SpotifyApp2
//
//  Created by Ilona Punya on 15.04.23.
//

import Foundation

class PlaylistViewModel {
    var playlist: Playlist?
    var playlistDetails: Observable<PlaylistDetailsResponse?> = Observable(nil)
    var playlistTracks: [Track] = []
    
    var isFromLibrary: Bool = false
    
    init(playlist: Playlist, isFromLibrary: Bool = false) {
        self.playlist = playlist
        self.isFromLibrary = isFromLibrary
    }
    
    var trackCount: Int {
        return playlistTracks.count
    }
    
    func getTrackBy(_ number: Int) -> Track? {
        guard number < trackCount else { return nil }
        return playlistTracks[number]
    }
    
    func getTrackWithImageCollectionViewCellViewModel(_ number: Int) -> TrackWithImageCollectionViewCellViewModel {
        let track = getTrackBy(number)
        return TrackWithImageCollectionViewCellViewModel(trackTitle: track?.name ?? "", artistName: track?.artists.first?.name ?? "", coverImageURL: URL(string: track?.album?.images.first?.url ?? ""))
    }
    
    func getHeaderViewModel() -> PlaylistAlbumHeaderCollectionReusableViewViewModel {
        return PlaylistAlbumHeaderCollectionReusableViewViewModel(
            name: playlistDetails.value?.name ?? "", owner: playlistDetails.value?.owner.display_name ?? "", artworURL: URL(string: playlistDetails.value?.images.first?.url ?? ""), supplemetryInfo: playlistDetails.value?.followers.total, description: playlistDetails.value?.description ?? "")
    }
    
    func trackTapped(_ trackNumber: Int, completion: @escaping (Bool) -> Void) {
        guard let track = playlistDetails.value?.tracks.items[trackNumber].track else { return }
        PlaybackPresenter.shared.playSong(track: track) { result in
            completion(result)
        }
    }
    
    func fetchPlaylistData() {
        guard let id = playlist?.id else { return }
        APICaller.shared.getPlaylistInfoById(id) { [weak self] result in
            switch result {
            case .success(let playlistDetails):
                self?.playlistDetails.value = playlistDetails
                self?.filterAndSaveTracks()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func filterAndSaveTracks() {
        playlistDetails.value?.tracks.items.forEach { item in
            if item.track != nil {
                playlistTracks.append(item.track!)
            }
        }
    }
    
    func addButtonTapped() {
        guard let id = playlist?.id else { return }
        APICaller.shared.manipulatePlaylist(id, method: .PUT) { result in
            if result {
                HapticsManager.shared.vibrate(for: .success)
            }
        }
    }
    
    func removeButtonTapped(completion: @escaping (Bool) -> Void) {
        guard let id = playlist?.id else { return }
        APICaller.shared.manipulatePlaylist(id, method: .DELETE) { result in
            if result {
                HapticsManager.shared.vibrate(for: .success)
            }
            completion(result)
        }
    }
}
