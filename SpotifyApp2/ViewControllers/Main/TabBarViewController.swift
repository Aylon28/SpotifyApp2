//
//  TabBarViewController.swift
//  SpotifyApp2
//
//  Created by Ilona Punya on 7.04.23.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        tabBar.backgroundColor = .systemGray6
        
        let nav1 = createBrowseVC()
        let nav2 = createSearchVC()
        let nav3 = createLibraryVC()
        
        setViewControllers([nav1, nav2, nav3], animated: true)
    }
    
    private func createBrowseVC() -> UINavigationController {
        let vc = HomeViewController()
        vc.title = "Browse"
        vc.navigationItem.largeTitleDisplayMode = .always
        
        let nav = UINavigationController(rootViewController: vc)
        nav.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 1)
        nav.navigationBar.tintColor = .label
        nav.navigationBar.prefersLargeTitles = true
        return nav
    }
    
    private func createSearchVC() -> UINavigationController {
        let vc = SearchViewController()
        vc.title = "Search"
        vc.navigationItem.largeTitleDisplayMode = .always
        
        let nav = UINavigationController(rootViewController: vc)
        nav.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 1)
        nav.navigationBar.tintColor = .label
        nav.navigationBar.prefersLargeTitles = true
        return nav
    }
    
    private func createLibraryVC() -> UINavigationController {
        let vc = LibraryViewController()
        vc.title = "Library"
        vc.navigationItem.largeTitleDisplayMode = .always
        
        let nav = UINavigationController(rootViewController: vc)
        nav.tabBarItem = UITabBarItem(title: "Library", image: UIImage(systemName: "music.note.list"), tag: 1)
        nav.navigationBar.tintColor = .label
        nav.navigationBar.prefersLargeTitles = true
        return nav
    }

}
