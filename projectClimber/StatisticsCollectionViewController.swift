//
//  StatisticsCollectionViewController.swift
//  projectClimber
//
//  Created by Ivan Pryhara on 4.02.22.
//

import UIKit
import RealmSwift


class StatisticsCollectionViewController: UICollectionViewController {
    
    enum Section: Hashable {
        case statistics
        case workouts
    }
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Object>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Object>
    
    var workouts = [Object]()
    var statistics = Statistics()
    var dataSource: DataSource!
    var token: NotificationToken?
    // Array where kept sections
    var sections = [Section]()

    override func viewDidLoad() {
        super.viewDidLoad()
//        print("STATISTICS COLLECTION VIEW - VIEW DID LOAD")
        self.collectionView!.register(WorkoutCollectionViewCell.self, forCellWithReuseIdentifier: WorkoutCollectionViewCell.reuseIdentifier)
        self.collectionView!.register(StatisticsCollectionViewCell.self, forCellWithReuseIdentifier: StatisticsCollectionViewCell.reuseIdentifier)

        collectionView.collectionViewLayout = createLayout()
        
        workouts = RealmManager.sharedInstance.fetch(isResultReversed: true)
        statistics.combineWorkoutTime(in: workouts)
        observeRealm()
        viewConfiguration()
        configureDataSource()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = sections[indexPath.section]
        // If section is .workouts we can push to stats for specific workout
        if section == .workouts {
            // Move to statistics table view
            let workoutToShow = workouts[indexPath.item]
            let tableStatView = WorkoutStatisticsTableViewController()
            tableStatView.workout = workoutToShow as? Workout
            // Prevent table view to have a large title
            tableStatView.navigationItem.largeTitleDisplayMode = .never
            
            navigationController?.pushViewController(tableStatView, animated: true)
        }
        // ... otherwise nothing happens
    }
    //MARK: Helper methods
    func viewConfiguration() {
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Statistics"
    }
    
    func createLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment -> NSCollectionLayoutSection? in
            let section = self.sections[sectionIndex]
            // Switch between different sections
            // And create theirown layout for particular section
            switch section {
            case .statistics:
                let padding: CGFloat = 10
                
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.4))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.4))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
                
                group.interItemSpacing = .fixed(padding * 2)
                
                group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: padding, bottom: 0, trailing: padding)
                
                let section = NSCollectionLayoutSection(group: group)
                return section
                
            case .workouts:
                let padding: CGFloat = 10
                
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.2))
                
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.2))
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
                
                group.interItemSpacing = .fixed(padding * 2)
                        
                group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: padding, bottom: 0, trailing: padding)
                
                let section = NSCollectionLayoutSection(group: group)
                
                return section
            }
        }
        return layout
        
    }
    
    func observeRealm() {
        token = RealmManager.sharedInstance.realm.observe { notification, realm in
            self.workouts = RealmManager.sharedInstance.fetch(isResultReversed: true)
            self.statistics.combineWorkoutTime(in: self.workouts)
            // Making new snapshot with new values
            var snapshot = Snapshot()
            snapshot.appendSections([.statistics])
            snapshot.appendItems([self.statistics], toSection: .statistics)
            // Reaload items. In this case only one item with statistics
            snapshot.reloadItems([self.statistics])
            
            snapshot.appendSections([.workouts])
            snapshot.appendItems(self.workouts, toSection: .workouts)
            // Apply to data source, hence update UI
            self.dataSource.apply(snapshot)
            print("OBSERVED")
        }
    }
    
    //MARK: Data Source configuring
    func configureDataSource() {
        dataSource = .init(collectionView: collectionView, cellProvider: { collectionView, indexPath, workout -> UICollectionViewCell? in
            let section = self.sections[indexPath.section]
            // Switch between sections
            // Configuring cell depends on section
            switch section {
            case .statistics:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StatisticsCollectionViewCell.reuseIdentifier, for: indexPath) as! StatisticsCollectionViewCell
                
                cell.configure(with: self.statistics)
                cell.layer.cornerRadius = 10
                cell.backgroundColor = .systemFill
                
                return cell
            case .workouts:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WorkoutCollectionViewCell.reuseIdentifier, for: indexPath) as! WorkoutCollectionViewCell
                
                cell.configure(with: workout)
                cell.layer.cornerRadius = 10
                cell.backgroundColor = .systemOrange
                
                return cell
            }
        })

        var snapshot = Snapshot()
        // add each seciton to the snapshot
        snapshot.appendSections([.statistics])
        snapshot.appendItems([statistics], toSection: .statistics)
        
        snapshot.appendSections([.workouts])
        snapshot.appendItems(workouts, toSection: .workouts)
        // asign sections to the value of snapshot section identifiers
        sections = snapshot.sectionIdentifiers
        dataSource.apply(snapshot)
    }
}

