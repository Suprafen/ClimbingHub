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
    init(userRealmConfiguration: Realm.Configuration, workoutRealmConfiguration: Realm.Configuration, user: User? = nil) {
        self.workoutRealmConfiguration = workoutRealmConfiguration
        self.userRealm = try! Realm(configuration: userRealmConfiguration)
        self.userData = user
        print("USER REALM URL: ", userRealmConfiguration.fileURL)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveUser()
        checkForUser()
        let workoutViewController = UINavigationController(rootViewController: WorkoutViewController(userData: self.userData, realmConfiguration: workoutRealmConfiguration))
        workoutViewController.title = "Workout"
        self.tabBar.tintColor = .systemBlue.withAlphaComponent(0.8)

        let statisticsViewController = UINavigationController(rootViewController: StatisticsCollectionViewController( workoutRealmConfiguration: self.workoutRealmConfiguration))
        statisticsViewController.title = "Overview"
        
        let profileSettingsTableViewController = UINavigationController(rootViewController: ProfileSettingsTableViewController(style: .insetGrouped, userData: self.userData))
        setViewControllers([statisticsViewController, workoutViewController, profileSettingsTableViewController], animated: false)
        profileSettingsTableViewController.title = "Profile"
        
        tabBar.items?[0].image = UIImage(systemName: "rectangle.grid.1x2")
        tabBar.items?[1].image = UIImage(systemName: "arrowtriangle.right.circle")
        tabBar.items?[2].image = UIImage(systemName: "person.circle")
    }
    
    func saveUser() {
        if let userData = userData {
            try! userRealm.write {
                userRealm.add(userData)
            }
        }
    }
    // Check whether realm contains this user
    // If it is use this user
    func checkForUser() {
        print("DO SOMETHING FUNC")
        guard let userID = app.currentUser?.id else {
            return
        }
        print("USER ID - \(userID)")
        try! userRealm.write {
            let resultsObjects = userRealm.objects(User.self)
            let currentUser = resultsObjects.filter { user in
                user.userID == "user=\(userID)"
            }
            guard let userData = currentUser.first else { return }
            self.userData = userData
            print("USER_DATA: ", userData)
            print("DO SOMETHING END")
        }
    }
}
