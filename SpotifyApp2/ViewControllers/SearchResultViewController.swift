//
//  SearchResultViewController.swift
//  SpotifyApp2
//
//  Created by Ilona Punya on 9.04.23.
//

import UIKit

class SearchResultViewController: UIViewController {
    var viewModel = SearchResultViewModel()
    
    lazy private var tableViewAdapter = SearchResultTableViewAdapter(viewModel: viewModel)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableViewAdapter)
        setupBindings()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableViewAdapter.frame = view.bounds
    }
    
    private func setupBindings() {
        viewModel.sections.bind { [weak self] _ in
            self?.tableViewAdapter.reloadData()
        }
    }

}
