//
//  StatisticsCollectionViewController.swift
//  projectClimber
//
//  Created by Ivan Pryhara on 4.02.22.
//

import UIKit
import RealmSwift


class StatisticsCollectionViewController: UICollectionViewController {
    
    enum Section {
        case main
    }
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Object>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Object>
    
    var workouts = [Object]()
    var dataSource: DataSource!
    var token: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("STATISTICS COLLECTION VIEW - VIEW DID LOAD")
        self.collectionView!.register(WorkoutCollectionViewCell.self, forCellWithReuseIdentifier: WorkoutCollectionViewCell.reuseIdentifier)
        workouts = RealmManager.sharedInstance.fetch(object: FingerWorkout.self)
        observeRealm()
        viewConfiguration()
        configureDataSource()
        collectionView.setCollectionViewLayout(createLayout(), animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("STATISTICS COLLECTION VIEW - VIEW DID APPEAR")
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(self.workouts, toSection: .main)
        self.dataSource.apply(snapshot)
    }
    
    func viewConfiguration() {
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Statistics"
    }
    
    func createLayout() -> UICollectionViewLayout {
        let padding: CGFloat = 10
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalWidth(0.5))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.5))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        
        group.interItemSpacing = .fixed(padding * 2)
                
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: padding, bottom: 0, trailing: padding)
        
        let section = NSCollectionLayoutSection(group: group)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    func observeRealm() {
        token = RealmManager.sharedInstance.realm.observe { notification, realm in
            self.workouts = RealmManager.sharedInstance.fetch(object: FingerWorkout.self)
            print("OBSERVED")
        }
    }
    
    //MARK: Data Source configuring
    func configureDataSource() {
        dataSource = .init(collectionView: collectionView, cellProvider: { collectionView, indexPath, workout -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WorkoutCollectionViewCell.reuseIdentifier, for: indexPath) as! WorkoutCollectionViewCell
            
            cell.configure(with: workout)
            cell.layer.cornerRadius = 10
            cell.backgroundColor = .systemOrange
            return cell
            
        })
        //where I need to safe my workouts?????
        //temporarly I save them in this view controller
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(workouts, toSection: .main)
        dataSource.apply(snapshot)
    }
}
