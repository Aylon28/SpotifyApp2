//
//  SearchResultTableViewAdapter.swift
//  SpotifyApp2
//
//  Created by Ilona Punya on 26.06.23.
//

import Foundation
import UIKit

class SearchResultTableViewAdapter: UITableView {
    var viewModel: SearchResultViewModel!
    
    init(viewModel: SearchResultViewModel) {
        super.init(frame: .zero, style: .grouped)
        register(DefaultTableViewCell.self, forCellReuseIdentifier: DefaultTableViewCell.identifier)
        register(SubtitleTableViewCell.self, forCellReuseIdentifier: SubtitleTableViewCell.identifier)
        
        self.viewModel = viewModel
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
    
    func setup() {
        dataSource = self
        delegate = self
    }
}

extension SearchResultTableViewAdapter: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.didTapTableViewRowAt(indexPath)
    }
    
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
            break
//            DispatchQueue.main.async { [weak self] in
//                self?.showPlaylistView(track.id)
//            }
        case .artist(let artist):
            viewModel.saveArtist(artist.id)
        }
    }
    
//    private func showPlaylistView(_ trackId: String) {
//        let vc = LibraryViewController()
//        vc.viewModel.playlistSelectionHandler = { [weak self] playlistId in
//            self?.viewModel.saveTrack(trackId, playlisId: playlistId)
//        }
//        present(vc, animated: true)
//    }
}

extension SearchResultTableViewAdapter: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.sectionContentCount(section)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        print(viewModel.sectionsCount)
        return viewModel.sectionsCount
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
        viewModel.getSectionTitle(section)
    }
    
}
