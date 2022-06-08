//
//  SceneDelegate.swift
//  projectClimber
//
//  Created by Ivan Pryhara on 21.01.22.
//

import UIKit
import RealmSwift

let app = RealmSwift.App(id: "climbinghub-fclag")

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: windowScene)
        window?.makeKeyAndVisible()
        let rootViewController = UINavigationController(rootViewController: EmailSentViewController(email: "email@mail.com"))
        window?.rootViewController = rootViewController
//        guard let userActivity = connectionOptions.userActivities.first ?? session.stateRestorationActivity else {
//            window = UIWindow(windowScene: windowScene)
//            window?.makeKeyAndVisible()
//            let rootViewController = UINavigationController(rootViewController: WelcomeViewController())
//            window?.rootViewController = rootViewController
//            return
//        }
//
//        window = UIWindow(windowScene: windowScene)
//        window?.makeKeyAndVisible()
//        if configure(window: window, with: userActivity) {
//            scene.userActivity = userActivity
//        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        if let userActivity = window?.windowScene?.userActivity {
            userActivity.becomeCurrent()
        }
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
        if let userActivity = window?.windowScene?.userActivity {
            userActivity.resignCurrent()
        }
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


    // MARK: Helper methods
    func retreiveController(for userID: String) -> UIViewController {
        let userConfig = app.currentUser!.configuration(partitionValue: "user=\(userID)")
        let workoutConfig = app.currentUser!.configuration(partitionValue: "\(userID)")
        
        let tabarController = TabBarController(userRealmConfiguration: userConfig, workoutRealmConfiguration: workoutConfig)
        
        return tabarController
    }
    
    func configure(window: UIWindow?, with activity: NSUserActivity) -> Bool{
        var succeeded = false
        
        window?.rootViewController = UINavigationController(rootViewController: WelcomeViewController())
        
        if let userInfo = activity.userInfo {
            if let navigationController = window?.rootViewController as? UINavigationController {
                if let userID = userInfo[SceneDelegate.userIdForTabBar] as? String, userID.isEmpty != true, app.currentUser?.isLoggedIn != nil{
                    
                    let tabbarController = retreiveController(for: userID)
                    
                    tabbarController.modalPresentationStyle = .fullScreen
                    
                    navigationController.present(tabbarController, animated: false)
                } else if let userID = userInfo[SceneDelegate.userIdForTabBar] as? String, userID == SceneDelegate.userIdForLocalRealm {
                    let tabBarController = TabBarController()
                    
                    tabBarController.modalPresentationStyle = .fullScreen
                    
                    navigationController.present(tabBarController, animated: false)
                }
                
            }
            succeeded = true
        }
        return succeeded
    }
}
