//
//  HomeViewController.swift
//  SpotifyApp2
//
//  Created by Ilona Punya on 7.04.23.
//

import UIKit

class HomeViewController: UIViewController {
    var viewModel = HomeViewModel()
    
    private let refreshControl: UIRefreshControl = {
        let rc = UIRefreshControl()
        return rc
    }()
    
    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection in
            CollectionViewLayout.createHomeViewCollectionViewLayout(sectionIndex: sectionIndex)
    })

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupCollectionView()
        setupRefreshControl()
        setupBindings()
        viewModel.fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .always
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    private func setupBindings() {
        viewModel.sections.bind { [unowned self] _ in
            self.collectionView.reloadData()
        }
    }
    
    private func setupRefreshControl() {
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(didRefresh(_:)), for: .valueChanged)
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .done, target: self, action: #selector(didTapSettingsButton))
    }
    
    @objc private func didTapSettingsButton() {
        let vc = SettingsViewController()
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didRefresh(_ sender: UIRefreshControl) {
        viewModel.fetchData()
        sender.endRefreshing()
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(NewReleasesCollectionViewCell.self, forCellWithReuseIdentifier: NewReleasesCollectionViewCell.identifier)
        collectionView.register(PlaylistCoverCollectionViewCell.self, forCellWithReuseIdentifier: PlaylistCoverCollectionViewCell.identifier)
        collectionView.register(TrackWithImageCollectionViewCell.self, forCellWithReuseIdentifier: TrackWithImageCollectionViewCell.identifier)
        collectionView.register(SectionTitleCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: SectionTitleCollectionReusableView.identifier)
    }

}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getSectionItemsCount(section)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.getSectionsCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let type = viewModel.sections.value[indexPath.section]
        
        switch type {
        case .newReleases(let albums):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewReleasesCollectionViewCell.identifier, for: indexPath) as? NewReleasesCollectionViewCell else { return UICollectionViewCell() }
            let album = albums[indexPath.row]
            cell.configure(viewModel: NewReleasesCollectionViewCellViewModel(title: album.name,
                                                                             coverImageURL: URL(string: album.images.first?.url ?? "")))
            return cell
        case .featuredPlaylists(let playlists):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlaylistCoverCollectionViewCell.identifier, for: indexPath) as? PlaylistCoverCollectionViewCell else { return UICollectionViewCell() }
            let playlist = playlists[indexPath.row]
            cell.configure(viewModel: PlaylistCoverCollectionViewCellViewModel(playlistName: playlist.name,
                                                                                  ownerName: playlist.owner.display_name,
                                                                                  coverURL: URL(string: playlist.images.first?.url ?? "")))
            return cell
        case .topTracks(let tracks):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewReleasesCollectionViewCell.identifier, for: indexPath) as? NewReleasesCollectionViewCell else { return UICollectionViewCell() }
            let track = tracks[indexPath.row]
            cell.configure(viewModel: NewReleasesCollectionViewCellViewModel(title: track.name,
                                                                             coverImageURL: URL(string: track.album?.images.first?.url ?? "")))
            return cell
        case .allTimeFavourites(let tracks):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackWithImageCollectionViewCell.identifier, for: indexPath) as? TrackWithImageCollectionViewCell else { return UICollectionViewCell() }
            let track = tracks[indexPath.row]
            cell.configure(viewModel: TrackWithImageCollectionViewCellViewModel(trackTitle: track.name,
                                                                                artistName: track.artists.first?.name ?? "",
                                                                                coverImageURL: URL(string: track.album?.images.first?.url ?? "")))
            return cell
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: SectionTitleCollectionReusableView.identifier,
            for: indexPath) as? SectionTitleCollectionReusableView, kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        header.configure(title: viewModel.sections.value[indexPath.section].sectionTitle)
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let type = viewModel.sections.value[indexPath.section]
        switch type {
        case .newReleases(let albums):
            showAlbumView(album: albums[indexPath.row])
        case .featuredPlaylists(let playlists):
            showPlaylistView(playlist: playlists[indexPath.row])
        case .topTracks(let tracks), .allTimeFavourites(let tracks):
            viewModel.trackTapped(indexPath) { [weak self] result in
                DispatchQueue.main.async {
                    if result {
                        self?.showTrackView(track: tracks[indexPath.row])
                    } else {
                        self?.showErrorAlert()
                    }
                }
            }
        }
    }
    
    private func showAlbumView(album: Album) {
        let vc = AlbumViewController(viewModel: album)
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func showPlaylistView(playlist: Playlist) {
        let vc = PlaylistViewController(viewModel: playlist)
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func showTrackView(track: Track) {
        let vc = TrackViewController(viewModel: track)
        vc.navigationItem.largeTitleDisplayMode = .never
        present(UINavigationController(rootViewController: vc), animated: true)
    }
    
    private func showErrorAlert() {
        let alertController = UIAlertController(title: "Error", message: "Impossible to play the track", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alertController, animated: true)
    }
    
}
