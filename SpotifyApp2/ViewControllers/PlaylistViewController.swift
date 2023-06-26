//
//  PlaylistViewController.swift
//  SpotifyApp2
//
//  Created by Ilona Punya on 9.04.23.
//

import UIKit

class PlaylistViewController: UIViewController {
    var viewModel: PlaylistViewModel!
    
    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout { _, _ -> NSCollectionLayoutSection in
            CollectionViewLayout.createPlaylistAlbumViewCollectionViewLayout()
    })
    
    init(viewModel: Playlist, isFromLibrary: Bool = false) {
        self.viewModel = PlaylistViewModel(playlist: viewModel, isFromLibrary: isFromLibrary)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setupNavigationItem()
        setupBindings()
        viewModel.fetchPlaylistData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    private func setupNavigationItem() {
        if viewModel.isFromLibrary {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "minus"), style: .plain, target: self, action: #selector(removeButtonTapped))
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addButtonTapped))
        }
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(TrackWithImageCollectionViewCell.self, forCellWithReuseIdentifier: TrackWithImageCollectionViewCell.identifier)
        collectionView.register(PlaylistAlbumHeaderCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: PlaylistAlbumHeaderCollectionReusableView.identifier)
    }
    

    @objc private func addButtonTapped() {
        viewModel.addButtonTapped()
    }
    
    @objc private func removeButtonTapped() {
        viewModel.removeButtonTapped() { [weak self] result in
            DispatchQueue.main.async {
                if result {
                    self?.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    private func setupBindings() {
        viewModel?.playlistDetails.bind { [weak self] _ in
            self?.collectionView.reloadData()
        }
    }

}

extension PlaylistViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        viewModel.trackTapped(indexPath.row) { [weak self] result in
            DispatchQueue.main.async {
                if result {
                    self?.showTrackView(indexPath.row)
                } else {
                    self?.showErrorAlert()
                }
            }
        }
    }
    
    private func showTrackView(_ trackNumber: Int) {
        guard let track = viewModel.getTrackBy(trackNumber) else { return }
        let vc = TrackViewController(viewModel: track)
        vc.navigationItem.largeTitleDisplayMode = .never
        present(UINavigationController(rootViewController: vc), animated: true)
    }
    
    private func showErrorAlert() {
        let alertController = UIAlertController(title: "Error", message: "Impossible to play the track", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alertController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.trackCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackWithImageCollectionViewCell.identifier, for: indexPath) as? TrackWithImageCollectionViewCell else { return UICollectionViewCell() }
        let cellViewModel = viewModel.getTrackWithImageCollectionViewCellViewModel(indexPath.row)
        cell.configure(viewModel: cellViewModel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: PlaylistAlbumHeaderCollectionReusableView.identifier,
            for: indexPath
        ) as? PlaylistAlbumHeaderCollectionReusableView, kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        let headerViewModel = viewModel.getHeaderViewModel()
        header.configure(viewModel: headerViewModel, headerType: .playlist)
        return header
    }
    
    
}
