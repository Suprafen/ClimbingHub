//
//  TabBarController.swift
//  projectClimber
//
//  Created by Ivan Pryhara on 4.02.22.
//

import UIKit
import RealmSwift

class TabBarController: UITabBarController {

    let userRealm: Realm
    var userData: User?
    var workoutRealmConfiguration: Realm.Configuration
    init(userRealmConfiguration: Realm.Configuration, workoutRealmConfiguration: Realm.Configuration) {
        self.workoutRealmConfiguration = workoutRealmConfiguration
        self.userRealm = try! Realm(configuration: userRealmConfiguration)
        let userInRealm = userRealm.objects(User.self)
        
        self.userData = userInRealm.first
        
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let workoutViewController = UINavigationController(rootViewController: WorkoutViewController(userData: self.userData, realmConfiguration: workoutRealmConfiguration))
        workoutViewController.title = "Workout"
        self.tabBar.tintColor = .systemBlue.withAlphaComponent(0.8)

        let statisticsViewController = UINavigationController(rootViewController: StatisticsCollectionViewController( workoutRealmConfiguration: self.workoutRealmConfiguration))
        statisticsViewController.title = "Overview"
        
        let profileSettingsTableViewController = UINavigationController(rootViewController: ProfileSettingsTableViewController(style: .insetGrouped))
        setViewControllers([statisticsViewController, workoutViewController, profileSettingsTableViewController], animated: false)
        profileSettingsTableViewController.title = "Profile"
        
        tabBar.items?[0].image = UIImage(systemName: "rectangle.grid.1x2")
        tabBar.items?[1].image = UIImage(systemName: "arrowtriangle.right.circle")
        tabBar.items?[2].image = UIImage(systemName: "person.circle")
    }
}
