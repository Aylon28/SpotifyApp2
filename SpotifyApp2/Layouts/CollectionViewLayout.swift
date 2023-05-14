//
//  CollectionViewLayout.swift
//  SpotifyApp2
//
//  Created by Ilona Punya on 3.05.23.
//

import Foundation
import UIKit

class CollectionViewLayout {
    static func createPlaylistViewCollectionViewLayout() -> NSCollectionLayoutSection {
        let supplementaryView = [
            NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1)),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        ]
        
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                                             heightDimension: .fractionalHeight(1)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 0, bottom: 2, trailing: 0)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                                                          heightDimension: .absolute(60)),
                                                       repeatingSubitem: item,
                                                       count: 1)
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = supplementaryView
        return section
    }
    
    static func createPlaylistAlbumViewCollectionViewLayout() -> NSCollectionLayoutSection {
        let supplementaryView = [
            NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1)),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        ]
        
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                                             heightDimension: .fractionalHeight(1)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 0, bottom: 2, trailing: 0)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                                                          heightDimension: .absolute(60)),
                                                       repeatingSubitem: item,
                                                       count: 1)
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = supplementaryView
        return section
    }
    
    static func createCategoryPlaylistsViewCollectionViewLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                                                             heightDimension: .fractionalHeight(1)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 10, bottom: 2, trailing: 10)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                                                          heightDimension: .fractionalWidth(0.6)),
                                                       repeatingSubitem: item,
                                                       count: 2)
        group.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    static func createCategoriesViewCollectionViewLayout() -> NSCollectionLayoutSection {
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
    }
    
    static func createHomeViewCollectionViewLayout(sectionIndex: Int) -> NSCollectionLayoutSection {
        let supplementaryView = [
            NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(70)),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        ]
        switch sectionIndex {
        case 0:
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                                                 heightDimension: .absolute(60)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                                                                              heightDimension: .absolute(60)),
                                                           repeatingSubitem: item,
                                                           count: 2)
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = supplementaryView
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
            return section
        case 1:
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                                                 heightDimension: .fractionalHeight(1)))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.45),
                                                                                              heightDimension: .absolute(250)),
                                                           repeatingSubitem: item,
                                                           count: 1)
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = supplementaryView
            section.orthogonalScrollingBehavior = .groupPaging
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
            return section
        case 2:
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                                                 heightDimension: .absolute(70)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
            let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.85),
                                                                                              heightDimension: .absolute(350)),
                                                         repeatingSubitem: item,
                                                         count: 5)
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = supplementaryView
            section.orthogonalScrollingBehavior = .groupPagingCentered
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
            return section
        case 3:
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                                                 heightDimension: .absolute(60)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 5, bottom: 1, trailing: 5)
            let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                                                            heightDimension: .absolute(60)),
                                                         repeatingSubitem: item,
                                                         count: 1)
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = supplementaryView
            return section
        default:
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                                                 heightDimension: .absolute(60)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                                                                              heightDimension: .absolute(60)),
                                                           repeatingSubitem: item,
                                                           count: 2)
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = supplementaryView
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
            return section
        }

    }
}
