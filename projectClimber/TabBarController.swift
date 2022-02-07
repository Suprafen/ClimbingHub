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
        
        let workoutViewController = WorkoutViewController()
        workoutViewController.title = "Workout"
        //default layout, the real one will be configured when view did load
        let statisticsViewController = UINavigationController(rootViewController: StatisticsCollectionViewController(collectionViewLayout: UICollectionViewLayout()))
        statisticsViewController.title = "Statistics"
        setViewControllers([statisticsViewController, workoutViewController], animated: false)
        
        // Do any additional setup after loading the view.
        
        tabBar.items?[0].image = UIImage(systemName: "text.justify")
        tabBar.items?[1].image = UIImage(systemName: "gear")
    }
    
}
