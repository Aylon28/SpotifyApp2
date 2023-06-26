//
//  LibraryViewController.swift
//  SpotifyApp2
//
//  Created by Ilona Punya on 7.04.23.
//

import SafariServices
import UIKit

class LibraryViewController: UIViewController {
    var viewModel: LibraryViewModel!
    
    private let segmentController: UISegmentedControl = {
        let segmentControl = UISegmentedControl(items: ["Playlists", "Albums", "Artists"])
        segmentControl.selectedSegmentIndex = 0
        segmentControl.selectedSegmentTintColor = .systemGreen
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentControl
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(SubtitleTableViewCell.self, forCellReuseIdentifier: SubtitleTableViewCell.identifier)
        tableView.register(DefaultTableViewCell.self, forCellReuseIdentifier: DefaultTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    init(playlistsAreOwnedByUser: Bool = false) {
        self.viewModel = LibraryViewModel(playlistsAreOwnedByUser: playlistsAreOwnedByUser)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        updateBarButtons()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .always
        viewModel.fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setAnchors()
    }
    
    private func setupBindings() {
        viewModel.albums.bind { [weak self] _ in
            self?.tableView.reloadData()
        }
        viewModel.playlists.bind { [weak self] _ in
            self?.tableView.reloadData()
        }
        viewModel.artists.bind { [weak self] _ in
            self?.tableView.reloadData()
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(segmentController)
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        segmentController.isHidden = viewModel.playlistSelectionHandler != nil ? true : false
        segmentController.addTarget(self, action: #selector(segmentValueChanged), for: .valueChanged)
    }
    
    @objc private func segmentValueChanged() {
        viewModel.segmentValueChanged(segmentController.selectedSegmentIndex)
        updateBarButtons()
    }
    
    private func updateBarButtons() {
        if viewModel.choosedSection == .playlists {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addButtonTapped))
        } else {
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    @objc private func addButtonTapped() {
        let alertController = UIAlertController(title: "Add playlist", message: "Write name and description", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Playlist name..."
        }
        alertController.addAction(UIAlertAction(title: "Cancel", style: .destructive))
        alertController.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            guard let playlistName = alertController.textFields?[0].text else { return }
            self?.viewModel.createPlaylistTapped(playlistName)
        })
        present(alertController, animated: true)
    }
    
    private func setAnchors() {
        NSLayoutConstraint.activate([
            segmentController.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            segmentController.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            segmentController.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.topAnchor.constraint(equalTo: segmentController.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: tabBarController?.tabBar.topAnchor ?? view.bottomAnchor),
            tableView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
    }
}

extension LibraryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard viewModel.playlistSelectionHandler == nil else {
            viewModel.playlistSelectionHandler!(viewModel.playlists.value[indexPath.row].id)
            dismiss(animated: true)
            return
        }

        switch viewModel.choosedSection {
        case .playlists:
            let vc = PlaylistViewController(viewModel: viewModel.playlists.value[indexPath.row], isFromLibrary: true)
            navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
        case .albums:
            let vc = AlbumViewController(viewModel: viewModel.albums.value[indexPath.row], isFromLibrary: true)
            navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
        case .artists:
            guard let url = viewModel.getArtistURL(indexPath.row)  else { return }
            let vc = SFSafariViewController(url: url)
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.rowsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModel.choosedSection {
        case .playlists:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SubtitleTableViewCell.identifier, for: indexPath) as? SubtitleTableViewCell else { return UITableViewCell() }
            let cellViewModel = viewModel.getSubtitleTableViewCellViewModel(indexPath.row)
            cell.configure(viewModel: cellViewModel)
            return cell
        case .albums:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SubtitleTableViewCell.identifier, for: indexPath) as? SubtitleTableViewCell else { return UITableViewCell() }
            let cellViewModel = viewModel.getSubtitleTableViewCellViewModel(indexPath.row)
            cell.configure(viewModel: cellViewModel)
            return cell
        case .artists:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DefaultTableViewCell.identifier, for: indexPath) as? DefaultTableViewCell else { return UITableViewCell() }
            let cellViewModel = viewModel.getDefaultTableViewCellViewModel(indexPath.row)
            cell.configure(viewModel: cellViewModel, isRounded: true)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}
