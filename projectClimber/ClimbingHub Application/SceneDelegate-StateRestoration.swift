//
//  SceneDelegate-StateRestoration.swift
//  ClimbingHub
//
//  Created by Ivan Pryhara on 5.06.22.
//

import UIKit

extension SceneDelegate {
    
    static let MainSceneActivity = { () -> String in
        let activityTypes = Bundle.main.infoDictionary?["NSUserActivityTypes"] as? [String]
        return activityTypes![0]
    }
    
    static let presentedTabBarControllerKey = "tabBarControllerPresentedKey" // Wether true, then tab bar presented
    static let userIdForTabBar = "UserIdForTabBar" // Key for user id tab bar
    static let userIdForLocalRealm = "LocalRealm"
    
    func stateRestorationActivity(for scene: UIScene) -> NSUserActivity? {
        if app.currentUser?.isLoggedIn != nil {
            if  let rootViewController = window?.rootViewController as? UINavigationController,
                let childViewController = rootViewController.topViewController as? SignInViewController,
                let tabBarViewController = childViewController.presentedViewController as? TabBarController {
                    tabBarViewController.updateUserActivity()
            }
        } else if let userInfo = scene.userActivity?.userInfo, userInfo[SceneDelegate.presentedTabBarControllerKey] != nil, userInfo[SceneDelegate.userIdForTabBar] as? String == "" {
            if  let rootViewController = window?.rootViewController as? UINavigationController,
                let tabBarViewController = rootViewController.presentedViewController as? TabBarController {
                    tabBarViewController.updateUserActivity()
            }
        }
        return scene.userActivity
    }
}
