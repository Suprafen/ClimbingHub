//
//  StatisticsCollectionViewController.swift
//  projectClimber
//
//  Created by Ivan Pryhara on 4.02.22.
//

import UIKit
import SwiftUI
import RealmSwift
import SafariServices

class StatisticsCollectionViewController: UICollectionViewController {
    
    let absenceOfWorkoutLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.80
        label.textColor = .systemGray3
        label.text = "No workouts here yet."
        
        return label
    }()
    // TODO: Rename this button, as well as method.
    // This one is responsible for moving us to the workout tab view
    let moveToTheTabButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        let button = UIButton()
        configuration.attributedTitle = "Move to workout tab"
        button.configuration = configuration
        button.addTarget(nil, action: #selector(moveToTheTabButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
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
    var workoutRealm: Realm
    
    init(workoutRealmConfiguration: Realm.Configuration) {
        // TODO: Try to place token initialization to this init
        self.workoutRealm = try! Realm(configuration: workoutRealmConfiguration)
        super.init(collectionViewLayout: UICollectionViewLayout())
    }
    
    deinit {
        token?.invalidate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO: Refactor this method. Just add a few functions and place there these calls.
        // Privacy button diclaration
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "checkerboard.shield")
        configuration.baseForegroundColor = .systemBlue.withAlphaComponent(0.8)
        //MARK: Cell Registration
        self.collectionView.register(WorkoutCollectionViewCell.self, forCellWithReuseIdentifier: WorkoutCollectionViewCell.reuseIdentifier)
        self.collectionView.register(StatisticsCollectionViewCell.self, forCellWithReuseIdentifier: StatisticsCollectionViewCell.reuseIdentifier)
//        self.collectionView.register(TestCollectionViewCell.self, forCellWithReuseIdentifier: TestCollectionViewCell.reuseIdentifier)
        
        // MARK: Supplementary View Registration
        self.collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: SupplementaryKind.header, withReuseIdentifier: SectionHeaderView.reuseIdentifier)
        self.collectionView.register(ShowMoreButtonHeaderView.self, forSupplementaryViewOfKind: SupplementaryKind.button, withReuseIdentifier: ShowMoreButtonHeaderView.reuseIdentifier)
        collectionView.collectionViewLayout = createLayout()
        
        // MARK: Other Set Ups
        self.workouts = Array(workoutRealm.objects(Workout.self)).sorted(by: {$0.date > $1.date})

        var counter = 0
        // Because we need to have only 3 workouts on the main screen in the collection view,
        // so we need next steps
        // If we have less than 4 workouts we simply take everything from the array.
        //
        // Otherwise,
        // We fetch workouts array we just got from the realm and get only 3 the latter workouts
        // and append them to the workoutsForSection var.
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
        configureDataSource()
        observeRealm()
        viewConfiguration()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // For removing the label and the button, which suggest moving to the workout window and start training,
        // if we have something to show
        if !workouts.isEmpty {
            absenceOfWorkoutLabel.isHidden = true
            moveToTheTabButton.isHidden = true
            collectionView.isScrollEnabled = true
        } else {
            collectionView.isScrollEnabled = false
            absenceOfWorkoutLabel.isHidden = false
            moveToTheTabButton.isHidden = false
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        NSLayoutConstraint.activate([
            absenceOfWorkoutLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            absenceOfWorkoutLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            moveToTheTabButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            moveToTheTabButton.topAnchor.constraint(equalTo: absenceOfWorkoutLabel.bottomAnchor, constant: 20)
        ])
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
        
        view.addSubview(absenceOfWorkoutLabel)
        view.addSubview(moveToTheTabButton)
        
        absenceOfWorkoutLabel.translatesAutoresizingMaskIntoConstraints = false
        moveToTheTabButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func createLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment -> NSCollectionLayoutSection? in
            let section = self.sections[sectionIndex]
            
            let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.98), heightDimension: .estimated(44))
            let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize, elementKind: SupplementaryKind.header, alignment: .topLeading)
            headerItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0)
            
            let showMoreButtonSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.98), heightDimension: .estimated(44))
            let showMoreButtonItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: showMoreButtonSize, elementKind: SupplementaryKind.button, alignment: .topLeading)
            showMoreButtonItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 20)
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

                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.98), heightDimension: .fractionalWidth(0.2))
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
                
                group.interItemSpacing = .fixed(padding * 2)
                        
                group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: padding, bottom: 0, trailing: padding)
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: padding, bottom: 0, trailing: 0)
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
        token = workoutRealm.observe { notification, realm in
            // Whether realm is empty we're not going to do with collection view
            // This only happens when account is being deleted.
            guard !self.workoutRealm.isEmpty else { return }

            self.workouts = Array(self.workoutRealm.objects(Workout.self)).sorted(by: {$0.date > $1.date})

            var counter = 0
            self.workoutsForSection.removeAll()
            // Getting 3 last wokrouts from workouts array
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
                
                let longestSplit: Int = self.biggestSplitInFingerWorkouts()
                cell.configure(with: statistics, quantityOfWorkouts: self.workouts.count, longestAttemptOnHangboard: longestSplit)

                cell.layer.cornerRadius = 15
                cell.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.8)
                
                return cell
            case .workouts:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WorkoutCollectionViewCell.reuseIdentifier, for: indexPath) as! WorkoutCollectionViewCell
                guard let workout = item as? Workout else { return UICollectionViewCell()}
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
                    sectionName = "Statistics"
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
        // Retreive the biggest split in the finger workouts
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
        
        let viewToGo = WorkoutsHistoryCollectionViewController(collectionViewLayout: UICollectionViewLayout())
        guard let workouts = self.workouts as? [Workout] else { return }
        viewToGo.workouts = workouts
        viewToGo.navigationItem.largeTitleDisplayMode = .always
        navigationController?.pushViewController(viewToGo, animated: true)
    }
    
    @objc func moveToTheTabButtonTapped(){
        tabBarController?.selectedIndex = 1
    }
}
