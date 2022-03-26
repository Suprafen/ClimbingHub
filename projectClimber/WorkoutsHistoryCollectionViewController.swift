//
//  WorkoutsHistoryCollectionViewController.swift
//  projectClimber
//
//  Created by Ivan Pryhara on 24.03.22.
//

import UIKit
import RealmSwift
import SwiftUI

private let headerKind = "header"

class WorkoutsHistoryCollectionViewController: UICollectionViewController {
    
    enum Section {
        case main
    }
    
//    typealias DataSource = UICollectionViewDiffableDataSource<SectionForHistory, Object>
//    typealias Snapshot = NSDiffableDataSourceSnapshot<SectionForHistory, Object>
    
    let monthDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        
//        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .full
        dateFormatter.dateFormat = "MMMM yyyy"
        return dateFormatter
    }()
    
//    var dataSource: DataSource!
    var workouts: [Workout] = []
    var sections = [SectionForHistory]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView!.register(WorkoutCollectionViewCell.self, forCellWithReuseIdentifier: WorkoutCollectionViewCell.reuseIdentifier)
        self.collectionView.register(SectionHeaderWorkoutsHistoryView.self, forSupplementaryViewOfKind: headerKind, withReuseIdentifier: SectionHeaderWorkoutsHistoryView.reuseIdentifier)
        
        collectionView.setCollectionViewLayout(createLayout(), animated: false)
        
        configureView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateSections()
        collectionView.reloadData()
    }
    //MARK: Helper methods
    
    func configureView() {
        collectionView.backgroundColor = .systemGray6
        self.navigationItem.title = "Workouts"
    }
    
    func updateSections() {
        sections.removeAll()
        
        let grouped = Dictionary(grouping: workouts, by: { Calendar.current.date(from: Calendar.current.dateComponents([.month, .year], from: $0.date))! })
        
        for (date, workouts) in grouped.sorted(by: {$0.0 > $1.0}) {
            sections.append(SectionForHistory(title: monthDateFormatter.string(from: date) , workouts: workouts.sorted(by: {$0.date > $1.date})))
        }
        
        collectionView.reloadData()
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].workouts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WorkoutCollectionViewCell.reuseIdentifier, for: indexPath) as! WorkoutCollectionViewCell
        
        let workout = sections[indexPath.section].workouts[indexPath.item]
        
        cell.configure(with: workout)
        cell.layer.cornerRadius = 15
        cell.backgroundColor = .white
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderWorkoutsHistoryView.reuseIdentifier, for: indexPath) as! SectionHeaderWorkoutsHistoryView
        
        headerView.titleLabel.text = self.sections[indexPath.section].title
        
        return headerView
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedWorkout = sections[indexPath.section].workouts[indexPath.item]
        let statisticsTableView = WorkoutStatisticsTableViewController()
        statisticsTableView.workout = selectedWorkout
        statisticsTableView.navigationItem.largeTitleDisplayMode = .never
        
        navigationController?.pushViewController(statisticsTableView, animated: true)
    }
    
    func createLayout() -> UICollectionViewLayout {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(40))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: headerKind, alignment: .top)
        header.pinToVisibleBounds = true
        
        let padding: CGFloat = 10
                
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.2))
                
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.98), heightDimension: .fractionalWidth(0.2))
                
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
                
        group.interItemSpacing = .fixed(padding * 2)
                        
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: padding, bottom: 0, trailing: padding)
                
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: padding, leading: 10, bottom: padding, trailing: 0)
        
            // Show supplementary items only if workouts is not empty
//        if !self.workouts.isEmpty {
             section.boundarySupplementaryItems = [header]
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
//    func configureDataSource() {
//        dataSource = .init(collectionView: collectionView, cellProvider: { (collectionView, indexPath, workout) -> UICollectionViewCell? in
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WorkoutCollectionViewCell.reuseIdentifier, for: indexPath) as! WorkoutCollectionViewCell
//            cell.configure(with: workout)
//            return cell
//        })
//
//        dataSource.supplementaryViewProvider = {collectionView, kind, indexPath -> UICollectionReusableView? in
//            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderWorkoutsHistoryView.reuseIdentifier, for: indexPath) as! SectionHeaderWorkoutsHistoryView
//
//            headerView.titleLabel.text = self.sections[indexPath.section].title
//
//            return headerView
//        }
//
//        var snapshot = Snapshot()
//
//        snapshot.appendSections(self.sections)
//        snapshot.appendItems(workouts, toSection: SectionForHistory)
//
//    }
  
}
