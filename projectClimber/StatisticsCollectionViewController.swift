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
    
    enum SupplementaryKind {
       static let header = "header"
    }
    
    enum ObjectType {
        case workout
        case statistics
    }
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Object>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Object>
    
    var sections = [Section]()
    var workouts = [Object]()
    var statContainer = StatContainer()
    
    var dataSource: DataSource!
    var token: NotificationToken?

    override func viewDidLoad() {
        super.viewDidLoad()
//        print("STATISTICS COLLECTION VIEW - VIEW DID LOAD")
        self.collectionView.register(WorkoutCollectionViewCell.self, forCellWithReuseIdentifier: WorkoutCollectionViewCell.reuseIdentifier)
        self.collectionView.register(StatisticsCollectionViewCell.self, forCellWithReuseIdentifier: StatisticsCollectionViewCell.reuseIdentifier)
        self.collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: SupplementaryKind.header, withReuseIdentifier: SectionHeaderView.reuseIdentifier)
        collectionView.collectionViewLayout = createLayout()
        
        workouts = RealmManager.sharedInstance.fetch(isResultReversed: true)
        let workoutsTime: (totalTime: Int, timeOnHangBoard: Int) = Workout.combineWorkoutTime(in: workouts)
        // If workouts is empty I must prevent statConteiner's statistics from appending
        // Because if I didn't do this, I would see empty cells in the collection view
        if !workouts.isEmpty {
            statContainer.statistics.append(objectsIn: [
                Statistics(titleStatistics: "Total time", time: workoutsTime.totalTime, type: .totalTime),
                Statistics(titleStatistics: "Time on hangboard", time: workoutsTime.timeOnHangBoard, type: .hangBoard)
            ])
        }
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
        self.navigationItem.title = "Overview"
    }
    
    func createLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment -> NSCollectionLayoutSection? in
            let section = self.sections[sectionIndex]
            
            let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.92), heightDimension: .estimated(44))
            let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize, elementKind: SupplementaryKind.header, alignment: .top)
            headerItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 4)
            
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
                // Show supplementary items only if workouts is not empty
                if !self.workouts.isEmpty {
                    section.boundarySupplementaryItems = [headerItem]
                }
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
                // Show supplementary items only if workouts is not empty
                if !self.workouts.isEmpty {
                    section.boundarySupplementaryItems = [headerItem]
                }
                return section
            }
        }
        return layout
    }
    
    func observeRealm() {
        token = RealmManager.sharedInstance.realm.observe { notification, realm in
            self.workouts = RealmManager.sharedInstance.fetch(isResultReversed: true)
            // Remove everything from array in the container
            self.statContainer.statistics.removeAll()
            let workoutsTime: (totalTime: Int, timeOnHangBoard: Int) = Workout.combineWorkoutTime(in: self.workouts)
            // Append new statistics items
            self.statContainer.statistics.append(objectsIn: [
                Statistics(titleStatistics: "Total time", time: workoutsTime.totalTime, type: .totalTime),
                Statistics(titleStatistics: "Time on hangboard", time: workoutsTime.timeOnHangBoard, type: .hangBoard)
            ])
            // Making new snapshot with new values
            var snapshot = Snapshot()
            snapshot.appendSections([.statistics])
            snapshot.appendItems([self.statContainer], toSection: .statistics)
            // Reaload items. In this case only one item with statistics
            snapshot.reloadItems([self.statContainer])
            
            snapshot.appendSections([.workouts])
            snapshot.appendItems(self.workouts, toSection: .workouts)
            // Apply to data source, hence update UI
            self.dataSource.apply(snapshot)
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
                // Iterate through the list for making array,
                // Because diffable data source dosn't support list collection
                var tempStat = [Statistics]()
                for i in self.statContainer.statistics {
                    tempStat.append(i)
                }
                // Configure with array of Statistics objects
                cell.configure(with: tempStat)
                cell.layer.cornerRadius = 10
                // If i didn't add this conditional
                // Border would appear even though there's no data in the tempStat
                if !tempStat.isEmpty {
                    cell.layer.borderColor = UIColor.black.cgColor
                    cell.layer.borderWidth = 1
                }
                
                return cell
            case .workouts:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WorkoutCollectionViewCell.reuseIdentifier, for: indexPath) as! WorkoutCollectionViewCell
                //TODO: Change what you're configuring
                print("WORKOUT")
                print(workout)
                cell.configure(with: workout)
                cell.layer.cornerRadius = 10
                cell.layer.borderColor = UIColor.black.cgColor
                cell.layer.borderWidth = 1
                
                return cell
            }
        })
        
        //MARK: Supplementary view provider
        dataSource.supplementaryViewProvider = {collectionView, kind, indexPath -> UICollectionReusableView? in
            switch kind {
            case SupplementaryKind.header:
                let section = self.sections[indexPath.section]
                let sectionName: String
                switch section {
                case .statistics:
                    sectionName = "Statistics"
                case .workouts:
                    sectionName = "Workouts"
                }
                
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: SupplementaryKind.header, withReuseIdentifier: SectionHeaderView.reuseIdentifier, for: indexPath) as! SectionHeaderView
                headerView.setTitle(sectionName)
                
                return headerView
            default:
                return nil
            }
        }
        
        var snapshot = Snapshot()
        // add each seciton to the snapshot
        snapshot.appendSections([.statistics])
        snapshot.appendItems([self.statContainer], toSection: .statistics)
        
        snapshot.appendSections([.workouts])
        snapshot.appendItems(self.workouts, toSection: .workouts)
        // asign sections to the value of snapshot section identifiers
        sections = snapshot.sectionIdentifiers
        dataSource.apply(snapshot)
    }
}
