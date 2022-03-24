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
        static let button = "button"
    }
    
    enum ObjectType {
        case workout
        case statistics
    }
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Object>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Object>
    
    var sections = [Section]()
    var workouts = [Object]()
    var workoutsForSection = [Object]()
    var statistics = [Statistics]()
    
    var dataSource: DataSource!
    var token: NotificationToken?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.register(WorkoutCollectionViewCell.self, forCellWithReuseIdentifier: WorkoutCollectionViewCell.reuseIdentifier)
        self.collectionView.register(StatisticsCollectionViewCell.self, forCellWithReuseIdentifier: StatisticsCollectionViewCell.reuseIdentifier)
        self.collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: SupplementaryKind.header, withReuseIdentifier: SectionHeaderView.reuseIdentifier)
        self.collectionView.register(ShowMoreButtonHeaderView.self, forSupplementaryViewOfKind: SupplementaryKind.button, withReuseIdentifier: ShowMoreButtonHeaderView.reuseIdentifier)
        collectionView.collectionViewLayout = createLayout()
        
        workouts = RealmManager.sharedInstance.fetch(isResultReversed: true)
        
        var counter = 0
        
        if workouts.count < 4 {
            for workout in workouts {
                self.workoutsForSection.append(workout)
            }
        } else {
            while (counter < 3){
                
                self.workoutsForSection.append(workouts[counter])
                counter += 1
            }
        }
        
        let workoutsTime: (totalTime: Int, timeOnHangBoard: Int) = Workout.combineWorkoutTime(in: workouts)
        // If workouts is empty I must prevent statConteiner's statistics from appending
        // Because if I didn't do this, I would see empty cells in the collection view
        if !workouts.isEmpty {
            statistics.append(contentsOf: [
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
        collectionView.backgroundColor = .systemGray6
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Overview"
    }
    
    func createLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment -> NSCollectionLayoutSection? in
            let section = self.sections[sectionIndex]
            
            let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.92), heightDimension: .estimated(44))
            let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize, elementKind: SupplementaryKind.header, alignment: .topLeading)
            headerItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 0)
            
            let showMoreButtonSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.92), heightDimension: .estimated(44))
            let showMoreButtonItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: showMoreButtonSize, elementKind: SupplementaryKind.button, alignment: .topLeading)
            showMoreButtonItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 0)
            // Switch between different sections
            // And create theirown layout for particular section
            switch section {
            case .statistics:
                
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
//                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 4)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.92), heightDimension: .fractionalWidth(0.6))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
                let section = NSCollectionLayoutSection(group: group)
                // Show supplementary items only if workouts is not empty
                if !self.workouts.isEmpty {
                    section.boundarySupplementaryItems = [headerItem]
                }
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0)
                section.orthogonalScrollingBehavior = .groupPagingCentered
                
                return section
                
            case .workouts:
                let padding: CGFloat = 10
                
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.2))
                
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
//                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.2))
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
                
                group.interItemSpacing = .fixed(padding * 2)
                        
                group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: padding, bottom: 0, trailing: padding)
                
                let section = NSCollectionLayoutSection(group: group)
                // Show supplementary items only if workouts is not empty
                if !self.workouts.isEmpty {
                    section.boundarySupplementaryItems = [showMoreButtonItem]
                }
                return section
            }
        }
        return layout
    }
    
    func observeRealm() {
        token = RealmManager.sharedInstance.realm.observe { notification, realm in
            self.workouts = RealmManager.sharedInstance.fetch(isResultReversed: true)
            var counter = 0
            self.workoutsForSection.removeAll()
            
            if self.workouts.count < 4 {
                for workout in self.workouts {
                    self.workoutsForSection.append(workout)
                }
            } else {
                while (counter < 3){
                    
                    self.workoutsForSection.append(self.workouts[counter])
                    counter += 1
                }
            }
            
            // Remove everything from array
            self.statistics.removeAll()
            let workoutsTime: (totalTime: Int, timeOnHangBoard: Int) = Workout.combineWorkoutTime(in: self.workouts)
            // Append new statistics items
            self.statistics.append(contentsOf: [
                Statistics(titleStatistics: "Total time", time: workoutsTime.totalTime, type: .totalTime),
                Statistics(titleStatistics: "Time on hangboard", time: workoutsTime.timeOnHangBoard, type: .hangBoard)
            ])
            // Making new snapshot with new values
            var snapshot = Snapshot()
            snapshot.appendSections([.statistics])
            snapshot.appendItems(self.statistics, toSection: .statistics)
            // Reaload items. In this case only one item with statistics
            snapshot.reloadItems(self.statistics)
            
            snapshot.appendSections([.workouts])
            snapshot.appendItems(self.workoutsForSection, toSection: .workouts)
            // Apply to data source, hence update UI
            self.dataSource.apply(snapshot)
        }
    }
    
    //MARK: Data Source configuring
    func configureDataSource() {
        dataSource = .init(collectionView: collectionView, cellProvider: { collectionView, indexPath, item -> UICollectionViewCell? in
            let section = self.sections[indexPath.section]
            // Switch between sections
            // Configuring cell depends on section
            switch section {
            case .statistics:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StatisticsCollectionViewCell.reuseIdentifier, for: indexPath) as! StatisticsCollectionViewCell
                guard let statistics = item as? Statistics else { return UICollectionViewCell()}
                
                let biggestSplit: Int = self.biggestSplitInFingerWorkouts()
                cell.configure(with: statistics, countityOfWokrouts: self.workouts.count, longestAttemptOnHangboard: biggestSplit)
                
                cell.layer.cornerRadius = 15
                cell.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.8)
                
                return cell
            case .workouts:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WorkoutCollectionViewCell.reuseIdentifier, for: indexPath) as! WorkoutCollectionViewCell
                
                cell.configure(with: item)
                cell.layer.cornerRadius = 15

                cell.backgroundColor = .white
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
            case SupplementaryKind.button:
                let section = self.sections[indexPath.section]
                let sectionName: String
                switch section {
                case . workouts:
                    sectionName = "Workouts"
                default:
                    sectionName = ""
                }
                
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: SupplementaryKind.button, withReuseIdentifier: ShowMoreButtonHeaderView.reuseIdentifier, for: indexPath) as? ShowMoreButtonHeaderView
                headerView?.setTitle(sectionName)
                headerView?.showMoreButton.addTarget(self, action: #selector(self.showMoreButtonTapped), for: .touchUpInside)
                
                return headerView
            default:
                return nil
            }
        }
        
        var snapshot = Snapshot()
        // add each seciton to the snapshot
        snapshot.appendSections([.statistics])
        snapshot.appendItems(self.statistics, toSection: .statistics)
        
        snapshot.appendSections([.workouts])
        snapshot.appendItems(self.workoutsForSection, toSection: .workouts)
        // asign sections to the value of snapshot section identifiers
        sections = snapshot.sectionIdentifiers
        dataSource.apply(snapshot)
    }
    
    //MARK: Helper methods
    func biggestSplitInFingerWorkouts() -> Int {
        
        var maxSplit: Int = 0
        guard let workouts = self.workouts as? [Workout] else { return 0 }
        
        for workout in workouts {
            for split in workout.splits {
                if split > maxSplit {
                    maxSplit = split
                }
            }
        }
        
        return maxSplit
    }
    
    //MARK: Selectors
    
    @objc func showMoreButtonTapped() {
        //TODO: Add functionality to show more button
        let viewToGo = WorkoutsHistoryCollectionViewController(collectionViewLayout: UICollectionViewLayout())
        guard let workouts = self.workouts as? [Workout] else { return }
        viewToGo.workouts = workouts
        viewToGo.navigationItem.largeTitleDisplayMode = .always
        navigationController?.pushViewController(viewToGo, animated: true)
    }
}
