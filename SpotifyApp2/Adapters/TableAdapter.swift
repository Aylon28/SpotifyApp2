//
//  TableAdapter.swift
//  SpotifyApp2
//
//  Created by Ilona Punya on 4.06.23.
//

import Foundation
import UIKit

class TableAdapter: NSObject, UICollectionProtocol {
    private var tableView: UITableView!
    private var info: [String] = ["lo", "ve", "ly"]
    
    init(tableView: UITableView) {
        super.init()
        self.tableView = tableView
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func setupCollection() {
        
    }
}

extension TableAdapter: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return info.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DefaultTableViewCell.identifier, for: indexPath) as? DefaultTableViewCell else { return UITableViewCell() }
        cell.configure(viewModel: DefaultTableViewSystemImageCellViewModel(title: info[indexPath.row], coverImage: ""))
        return cell
    }
    
    
}





