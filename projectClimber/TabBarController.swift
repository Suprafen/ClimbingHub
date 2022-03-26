//
//  TabBarController.swift
//  projectClimber
//
//  Created by Ivan Pryhara on 4.02.22.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let workoutViewController = UINavigationController(rootViewController: WorkoutViewController())
        workoutViewController.title = "Workout"
        self.tabBar.tintColor = .black
        //default layout, the real one will be configured when view did load
        let statisticsViewController = UINavigationController(rootViewController: StatisticsCollectionViewController(collectionViewLayout: UICollectionViewLayout()))
        statisticsViewController.title = "Overview"
        setViewControllers([statisticsViewController, workoutViewController], animated: false)
        
        tabBar.items?[0].image = UIImage(systemName: "rectangle.grid.1x2")
        tabBar.items?[1].image = UIImage(systemName: "arrowtriangle.right.circle")
        
        // Choose which tab should appear first
        selectedIndex = 1
    }
}
