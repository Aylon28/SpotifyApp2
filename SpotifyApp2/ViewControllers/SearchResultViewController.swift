//
//  SearchResultViewController.swift
//  SpotifyApp2
//
//  Created by Ilona Punya on 9.04.23.
//

import UIKit

class SearchResultViewController: UIViewController {
    var viewModel = SearchResultViewModel()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(DefaultTableViewCell.self, forCellReuseIdentifier: DefaultTableViewCell.identifier)
        tableView.register(SubtitleTableViewCell.self, forCellReuseIdentifier: SubtitleTableViewCell.identifier)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupBindings()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupBindings() {
        viewModel.sections.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }

}

extension SearchResultViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let save = UIContextualAction(style: .normal, title: "Save") { [weak self] _, _, _ in
            self?.performAddAction(indexPath)
        }
        save.image = UIImage(systemName: "plus.circle")
        save.backgroundColor = .systemGreen
        return UISwipeActionsConfiguration(actions: [save])
    }
    
    private func performAddAction(_ indexPath: IndexPath) {
        guard let content = viewModel.getSectionContent(indexPath) else { return }
        switch content {
        case .album(let album):
            viewModel.saveAlbum(album.id)
        case .playlist(let playlist):
            viewModel.savePlaylist(playlist.id)
        case .track(let track):
            DispatchQueue.main.async { [weak self] in
                self?.showPlaylistView(track.id)
            }
        case .artist(let artist):
            viewModel.saveArtist(artist.id)
        }
    }
    
    private func showPlaylistView(_ trackId: String) {
        let vc = LibraryViewController()
        vc.viewModel.playlistSelectionHandler = { [weak self] playlistId in
            self?.viewModel.saveTrack(trackId, playlisId: playlistId)
        }
        present(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.didTapTableViewRowAt(indexPath)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sectionsCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sectionContentCount(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let result = viewModel.getSectionContent(indexPath) else { return UITableViewCell() }
        switch result {
        case .playlist, .album, .track:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SubtitleTableViewCell.identifier, for: indexPath) as? SubtitleTableViewCell else { return UITableViewCell() }
            let cellViewModel = viewModel.getSubtitleTableViewCellViewModel(indexPath)
            cell.configure(viewModel: cellViewModel)
            return cell
        case .artist:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DefaultTableViewCell.identifier, for: indexPath) as? DefaultTableViewCell else { return UITableViewCell() }
            let cellViewModel = viewModel.getDefaultTableViewCellViewModel(indexPath)
            cell.configure(viewModel: cellViewModel, isRounded: true)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.getSectionTitle(section)
    }
    
}
