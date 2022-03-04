//
//  HistoryCollectionViewCell.swift
//  projectClimber
//
//  Created by Ivan Pryhara on 17.02.22.
//

import UIKit
import RealmSwift

fileprivate enum Section {
    case main
}

class StatisticsCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "StatisticsCollectionViewCell"
    
    fileprivate typealias DataSource = UICollectionViewDiffableDataSource<Section, Object>
    fileprivate typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Object>
    fileprivate var dataSource: DataSource!
    
    let collecionView = UICollectionView(frame: CGRect(), collectionViewLayout: UICollectionViewLayout())
    

    override init (frame: CGRect) {
        super.init(frame: frame)
         
        collecionView.setCollectionViewLayout(createLayout(), animated: false)
        
        collecionView.register(SubCollectionViewCell.self, forCellWithReuseIdentifier: SubCollectionViewCell.reuseIdentifier)
        
        contentView.addSubview(collecionView)
        collecionView.translatesAutoresizingMaskIntoConstraints = false
        
        //corner radius for COLLECTION VIEW
        collecionView.layer.cornerRadius = 10
        
        NSLayoutConstraint.activate([
            collecionView.topAnchor.constraint(equalTo: topAnchor),
            collecionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collecionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collecionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError(" init?(coder: NSCoder) has not been implemented")
    }
    
    //MARK: Helper methods
    func createLayout() -> UICollectionViewLayout{
        let padding: CGFloat = 10
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.4))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        group.interItemSpacing = .fixed(padding * 2)
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: padding, bottom: 0, trailing: padding)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    func configure(with objects: [Object]) {
        print("Configure in statistics collection view cell")
        dataSource = .init(collectionView: collecionView, cellProvider: { (collectionView, indexPath, object) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SubCollectionViewCell.reuseIdentifier, for: indexPath) as! SubCollectionViewCell
            
            cell.configure(with: object)
            cell.layer.cornerRadius = 10
            
            return cell
        })
        
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(objects, toSection: .main)
        
        dataSource.apply(snapshot)
    }
}
