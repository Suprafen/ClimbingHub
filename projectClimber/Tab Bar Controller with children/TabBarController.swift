//
//  TabBarController.swift
//  projectClimber
//
//  Created by Ivan Pryhara on 4.02.22.
//

import UIKit
import RealmSwift

class TabBarController: UITabBarController {

    let userRealm: Realm?
    let email: String?
    var userData: User? = nil
    var workoutRealmConfiguration: Realm.Configuration
    
    init(userRealmConfiguration: Realm.Configuration? = nil,
         workoutRealmConfiguration: Realm.Configuration = Realm.localRealmConfig(),
         email: String? = nil) {
        self.workoutRealmConfiguration = workoutRealmConfiguration
        // Check for user config, wether nil, hence local realm
        if let userRealmConfiguration = userRealmConfiguration {
            self.userRealm = try! Realm(configuration: userRealmConfiguration)
        } else {
            self.userRealm = nil
        }
        self.email = email
//        print("USER REALM URL: ", userRealmConfiguration.fileURL ?? "__here_should_be_URL_to_a_user_realm__")
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateUserActivity()
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO: Refactor functions. Make them take arguments insted of just using properties
        
        // IF the user exists - do nothing
        // Otherwise, create new one and save to the realm
        // Another case is local realm
        // Check for user will return false
        // However 'createNewUser()' will be invalidated by guard statement
        checkForUser() ? () : createNewUser()

        let workoutViewController = UINavigationController(rootViewController: WorkoutViewController(userData: self.userData, realmConfiguration: workoutRealmConfiguration))
        workoutViewController.title = "Workout"
        self.tabBar.tintColor = .systemBlue.withAlphaComponent(0.8)

        let statisticsViewController = UINavigationController(rootViewController: StatisticsCollectionViewController( workoutRealmConfiguration: self.workoutRealmConfiguration))
        statisticsViewController.title = "Overview"
        
        let profileSettingsTableViewController = app.currentUser?.isLoggedIn != nil ? UINavigationController(rootViewController: ProfileSettingsTableViewController(style: .insetGrouped, userData: self.userData)) : UINavigationController(rootViewController:LocalProfileViewController())
        
        setViewControllers([statisticsViewController, workoutViewController, profileSettingsTableViewController], animated: false)
        profileSettingsTableViewController.title = "Profile"
        
        tabBar.items?[0].image = UIImage(systemName: "rectangle.grid.1x2")
        tabBar.items?[1].image = UIImage(systemName: "arrowtriangle.right.circle")
        tabBar.items?[2].image = UIImage(systemName: "person.circle")
    }
    
    func saveUser() {
        if let userData = userData {
            guard let userRealm = userRealm else { return }
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
        guard let userRealm = userRealm else { return false }
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
        guard let user = app.currentUser,
                let email = email else { return }
        // Create a new user based on given info:
        // Email and partition value(id)
        self.userData = User(email: email, userID: "user=\(user.id)", name: email)
        saveUser()
    }
    
    func updateUserActivity() {
        var currentUserActivity = view.window?.windowScene?.userActivity
        
        if currentUserActivity == nil {
            currentUserActivity = NSUserActivity(activityType: SceneDelegate.MainSceneActivity())
        }
        
        guard let userID = app.currentUser?.id else {
            // If there's no logged user, hence insted of userID paste empty string
            currentUserActivity?.addUserInfoEntries(from: [SceneDelegate.presentedTabBarControllerKey : true])
            currentUserActivity?.userInfo = [SceneDelegate.userIdForTabBar: SceneDelegate.userIdForLocalRealm]
            
            view.window?.windowScene?.userActivity = currentUserActivity
            return
        }
        
        currentUserActivity?.addUserInfoEntries(from: [SceneDelegate.presentedTabBarControllerKey : true])
        currentUserActivity?.userInfo  = [SceneDelegate.userIdForTabBar : "\(userID)"]
        
        view.window?.windowScene?.userActivity = currentUserActivity
    }
}
