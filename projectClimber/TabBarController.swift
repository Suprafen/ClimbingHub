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
        self.tabBar.tintColor = .systemBlue.withAlphaComponent(0.8)

        let statisticsViewController = UINavigationController(rootViewController: StatisticsCollectionViewController(collectionViewLayout: UICollectionViewLayout()))
        statisticsViewController.title = "Overview"
        setViewControllers([statisticsViewController, workoutViewController], animated: false)
        
        tabBar.items?[0].image = UIImage(systemName: "rectangle.grid.1x2")
        tabBar.items?[1].image = UIImage(systemName: "arrowtriangle.right.circle")
    }
}
