//
//  SceneDelegate.swift
//  AttendenceScanner
//
//  Created by Tushar on 15/01/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        setRootViewController(for: windowScene)
    }
    
    
    func setRootViewController(for windowScene: UIWindowScene) {
        let window = UIWindow(windowScene: windowScene)
        let rootVC: UIViewController

        if UserDefaultsManager.shared.isUserLoggedIn() {
            rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()!
        } else {
            rootVC = UIStoryboard(name: "Login", bundle: nil).instantiateInitialViewController()!
        }

        window.rootViewController = rootVC
        self.window = window
        window.makeKeyAndVisible()
        
    }
    
    func resetToLoginScreen() {
        guard let windowScene = self.window?.windowScene else { return }

        let loginVC = UIStoryboard(name: "Login", bundle: nil)
            .instantiateViewController(withIdentifier: "EventLoginViewController") as! EventLoginViewController

        let navController = UINavigationController(rootViewController: loginVC)

        let newWindow = UIWindow(windowScene: windowScene)
        newWindow.rootViewController = navController
        newWindow.makeKeyAndVisible()

        // Apply fade transition
        let transition = CATransition()
        transition.type = .fade
        transition.duration = 0.3
        newWindow.layer.add(transition, forKey: "transition")

        self.window = newWindow  // Set the new window
        UserDefaultsManager.shared.logoutUser()
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

