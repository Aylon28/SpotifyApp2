//
//  SearchViewController.swift
//  SpotifyApp2
//
//  Created by Ilona Punya on 7.04.23.
//

import SafariServices
import UIKit

class SearchViewController: UIViewController {
    var viewModel = SearchViewModel()
    
    let searchController: UISearchController = {
        let results = SearchResultViewController()
        let vc = UISearchController(searchResultsController: results)
        vc.searchBar.placeholder = "What do you want to listen to?"
        vc.searchBar.searchBarStyle = .minimal
        return vc
    }()
    
    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout { _, _ -> NSCollectionLayoutSection in
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                                                                 heightDimension: .fractionalHeight(1)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 10, bottom: 2, trailing: 10)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                                                              heightDimension: .fractionalWidth(0.3)),
                                                           repeatingSubitem: item,
                                                           count: 2)
            group.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            let section = NSCollectionLayoutSection(group: group)
            return section
    })

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupCollectionView()
        setupBindings()
        viewModel.fetchCategories()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    private func setupBindings() {
        viewModel.categories.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
    }
    
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let resultsController = searchController.searchResultsController as? SearchResultViewController,
              let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        viewModel.searchButtonClicked(query) { searchResults in
            resultsController.viewModel.delegate = self
            resultsController.viewModel.filterResults(results: searchResults)
        }
    }
}

extension SearchViewController: SearchResultViewModelDelegate {
    func didTapResult(_ result: SearchResult) {
        switch result {
        case .playlist(let playlist):
            let vc = PlaylistViewController(viewModel: playlist)
            navigationController?.pushViewController(vc, animated: true)
        case .track(let track):
            let vc = TrackViewController(viewModel: track)
            vc.navigationItem.largeTitleDisplayMode = .never
            present(UINavigationController(rootViewController: vc), animated: true)
        case .album(let album):
            let vc = AlbumViewController(viewModel: album)
            navigationController?.pushViewController(vc, animated: true)
        case .artist(let artist):
            guard let url = URL(string: artist.external_urls?["spotify"] ?? "") else { return }
            let vc = SFSafariViewController(url: url)
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        }
    }
    
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let category = viewModel.categories.value?[indexPath.row] else { return }
        let vc = CategoryViewController(viewModel: category)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.categoriesCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as? CategoryCollectionViewCell else { return UICollectionViewCell() }
        let cellViewModel = viewModel.getCategoryCollectionViewCellViewModel(indexPath.row)
        cell.configure(viewModel: cellViewModel)
        return cell
    }
    
    
}


