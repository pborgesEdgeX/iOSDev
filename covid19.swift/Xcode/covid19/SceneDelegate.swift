//
//  SceneDelegate.swift
//  covid19
//
//  Created by Daniel on 3/30/20.
//  Copyright © 2020 dk. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }

        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene

        let webController = WebViewController()
        webController.tabBarItem.image = UIImage(systemName: Constant.web.imageSystemName)
        webController.tabBarItem.title = Constant.web.name
        let webNavigationController = UINavigationController(rootViewController: webController)
        webNavigationController.navigationBar.prefersLargeTitles = true

        let dataController = DataViewController()
        dataController.tabBarItem.image = UIImage(systemName: Constant.data.imageSystemName)
        dataController.tabBarItem.title = Constant.data.name
        let dataNavigationController = UINavigationController(rootViewController: dataController)
        dataNavigationController.navigationBar.prefersLargeTitles = true

        let newsController = NewsViewController(tab: Constant.news)
        newsController.tabBarItem.image = UIImage(systemName: Constant.news.imageSystemName)
        let newsNavigationController = UINavigationController(rootViewController: newsController)
        newsNavigationController.navigationBar.prefersLargeTitles = true

        let bnoDeskTweetsController = TweetsViewController(tab: Constant.bno)
        bnoDeskTweetsController.tabBarItem.image = UIImage(systemName: Constant.bno.imageSystemName)

        let tweetsController = TweetsViewController(tab: Constant.twitter)
        tweetsController.tabBarItem.image = UIImage(systemName: Constant.twitter.imageSystemName)

        let tabController = UITabBarController()
        tabController.viewControllers = [
            webNavigationController,
            dataNavigationController,
            newsNavigationController,
            bnoDeskTweetsController,
            tweetsController
        ]

        window?.rootViewController = tabController
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
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


}
