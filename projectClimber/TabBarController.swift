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
    let email: String?
    var userData: User? = nil
    var workoutRealmConfiguration: Realm.Configuration
    
    init(userRealmConfiguration: Realm.Configuration, workoutRealmConfiguration: Realm.Configuration, email: String? = nil) {
        self.workoutRealmConfiguration = workoutRealmConfiguration
        self.userRealm = try! Realm(configuration: userRealmConfiguration)
        self.email = email
        print("USER REALM URL: ", userRealmConfiguration.fileURL ?? "__here_should_be_URL_to_a_user_realm__")
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO: Refactor functions. Make them take arguments insted of just using properties
        
        // IF the user exists - do nothing
        // Otherwise, create new one and save to the realm
        checkForUser() ? () : createNewUser()

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
    func checkForUser() -> Bool{
        guard let userID = app.currentUser?.id else {
            return false
        }
        var currentUser: User?
        try! userRealm.write {
            let resultsObjects = userRealm.objects(User.self)
            currentUser = resultsObjects.filter { user in
                user.userID == "user=\(userID)"
            }.first
        }
        // Check whether user was found
        // Return false if wasn't
        // Otherwise, true
        guard let userData = currentUser else { return false }
        self.userData = userData

        return true
    }
    
    func createNewUser() {
        let user = app.currentUser
        guard let user = user,
                let email = email else { return }
        // Create a new user based on given info:
        // Email and partition value(id)
        self.userData = User(email: email, userID: "user=\(user.id)", name: email)
        saveUser()
    }
}
