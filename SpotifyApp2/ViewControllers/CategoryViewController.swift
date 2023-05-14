//
//  CategoryViewController.swift
//  SpotifyApp2
//
//  Created by Ilona Punya on 11.04.23.
//

import UIKit

class CategoryViewController: UIViewController {
    var viewModel: CategoryViewModel!
    
    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout { _, _ -> NSCollectionLayoutSection in
            CollectionViewLayout.createCategoryPlaylistsViewCollectionViewLayout()
    })
    
    init(viewModel: Category) {
        self.viewModel = CategoryViewModel(category: viewModel)
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
        viewModel.fetchPlaylistsData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    private func setupNavigationItem() {
        title = viewModel.categoryName
        navigationItem.largeTitleDisplayMode = .never
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PlaylistCoverCollectionViewCell.self, forCellWithReuseIdentifier: PlaylistCoverCollectionViewCell.identifier)
    }
    
    private func setupBindings() {
        viewModel?.categoryPlaylists.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
}

extension CategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        showPlaylist(indexPath.row)
    }
    
    private func showPlaylist(_ number: Int) {
        guard let playlist = viewModel.getPlaylistByNumber(number) else { return }
        let vc = PlaylistViewController(viewModel: playlist)
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.playlistsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlaylistCoverCollectionViewCell.identifier, for: indexPath) as? PlaylistCoverCollectionViewCell else { return UICollectionViewCell() }
        let cellViewModel = viewModel.getPlaylistCoverCollectionViewCellViewModel(indexPath.row)
        cell.configure(viewModel: cellViewModel)
        return cell
    }
    
    
}
