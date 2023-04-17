//
//  AlbumViewModel.swift
//  SpotifyApp2
//
//  Created by Ilona Punya on 15.04.23.
//

import Foundation

class AlbumViewModel {
    var album: Album?
    var albumDetails: Observable<Album?> = Observable(nil)
    
    var isFromLibrary: Bool = false
    
    var tracksCount: Int {
        return albumDetails.value?.tracks?.items.count ?? 0
    }
    
    init(album: Album, isFromLibrary: Bool = false) {
        self.album = album
        self.isFromLibrary = isFromLibrary
    }
    
    func getTrackBy(_ number: Int) -> Track? {
        return albumDetails.value?.tracks?.items[number] ?? nil
    }
    
    func getTrackWithAlbumBy(_ number: Int) -> Track? {
        guard var track = albumDetails.value?.tracks?.items[number] else { return nil }
        track.album = album
        return track
    }
    
    func getTrackWithoutImageCollectionViewCellViewModel(_ number: Int) -> TrackWithoutImageCollectionViewCellViewModel {
        let track = getTrackBy(number)
        return TrackWithoutImageCollectionViewCellViewModel(
            trackTitle: track?.name ?? "",
            artistName: track?.artists.first?.name ?? "")
    }
    
    func getHeaderViewModel() -> PlaylistAlbumHeaderCollectionReusableViewViewModel {
        return PlaylistAlbumHeaderCollectionReusableViewViewModel(name: albumDetails.value?.name ?? "", owner: albumDetails.value?.artists.first?.name ?? "", artworURL: URL(string: albumDetails.value?.images.first?.url ?? ""), supplemetryInfo: albumDetails.value?.total_tracks, description: albumDetails.value?.release_date ?? "")
    }
    
    func fetchAlbumData() {
        guard let id = album?.id else { return }
        APICaller.shared.getAlbumInfoById(id) { [weak self] result in
            switch result {
            case .success(let album):
                self?.albumDetails.value = album
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func addButtonTapped() {
        guard let id = album?.id else { return }
        APICaller.shared.manipulateAlbum(id, method: .PUT) { result in
            if result {
                HapticsManager.shared.vibrate(for: .success)
            }
        }
    }
    
    func removeButtonTapped(completion: @escaping (Bool) -> Void) {
        guard let id = album?.id else { return }
        APICaller.shared.manipulateAlbum(id, method: .DELETE) { result in
            if result {
                HapticsManager.shared.vibrate(for: .success)
            }
            completion(result)
        }
    }
    
    func trackTapped(_ trackNumber: Int, completion: @escaping (Bool) -> Void) {
        guard let track = albumDetails.value?.tracks?.items[trackNumber] else { return }
        PlaybackPresenter.shared.playSong(track: track) { result in
            completion(result)
        }
    }
}
