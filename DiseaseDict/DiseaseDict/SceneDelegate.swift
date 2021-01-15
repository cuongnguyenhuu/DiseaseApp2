//
//  SceneDelegate.swift
//  DiseaseDict
//
//  Created by Currie on 11/22/20.
//  Copyright © 2020 Currie. All rights reserved.
//

import UIKit
import RealmSwift

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    private let categoryService = CategoryService()
    private let diseaseService = DiseaseService()
    private let settingService = SettingService()
    var isCategoryLoaded = false
    var isDiseaseLoaded = false
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        
        
        //        }
        
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        let storyboard = UIStoryboard(name: "LaunchScreen", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "LaunchViewController")
        window?.rootViewController = initialViewController
        window?.makeKeyAndVisible()
        
        self.settingService.getSettings { [self] setting in
            //            print( "AAAA:" + setting.hasNewData)
            //save data
            UserDefaults.standard.set(setting.isShowCategories, forKey: UserDefaultConfig.isShowCategories)
            UserDefaults.standard.set(setting.isShowAds, forKey: UserDefaultConfig.isShowAds)
            
            let oldHasNewData = UserDefaults.standard.string(forKey: UserDefaultConfig.hasNewData)
            if setting.hasNewData != oldHasNewData {
                print("Load new data")
                UserDefaults.standard.set(setting.hasNewData, forKey: UserDefaultConfig.hasNewData)
                self.loadNewData()
            } else {
                print("This is newest data")
                let storyboard = UIStoryboard(name: "Home", bundle: nil)
                let initialViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController")
                self.window?.rootViewController = initialViewController
                self.window?.makeKeyAndVisible()
            }
        }
        
        
        
    }
    
    func loadNewData(){
        let concurrentQueue = DispatchQueue(label: "com.some.concurrentQueue", attributes: .concurrent)
        
        concurrentQueue.sync {
            self.categoryService.getCategories { categories, error in
                
                if !error {
                    CategoryRealmService.shared.saveCategories(categories: categories) { finished in
                        self.isCategoryLoaded = true
                        if self.isCategoryLoaded && self.isDiseaseLoaded {
                            let storyboard = UIStoryboard(name: "Home", bundle: nil)
                            let initialViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController")
                            self.window?.rootViewController = initialViewController
                            self.window?.makeKeyAndVisible()
                        }
                    }
                } else {
                    self.isCategoryLoaded = true
                    if self.isCategoryLoaded && self.isDiseaseLoaded {
                        let storyboard = UIStoryboard(name: "Home", bundle: nil)
                        let initialViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController")
                        self.window?.rootViewController = initialViewController
                        self.window?.makeKeyAndVisible()
                    }
                }
            }
        }
        concurrentQueue.sync {
            self.diseaseService.getAllDiseases { diseases, error in
                if !error {
                    DiseaseRealmService.shared.saveAll(diseases: diseases) {  finished in
                        self.isDiseaseLoaded = true
                        if self.isCategoryLoaded && self.isDiseaseLoaded {
                            let storyboard = UIStoryboard(name: "Home", bundle: nil)
                            let initialViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController")
                            self.window?.rootViewController = initialViewController
                            self.window?.makeKeyAndVisible()
                        }
                    }
                } else {
                        self.isDiseaseLoaded = true
                    if self.isCategoryLoaded && self.isDiseaseLoaded {
                        let storyboard = UIStoryboard(name: "Home", bundle: nil)
                        let initialViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController")
                        self.window?.rootViewController = initialViewController
                        self.window?.makeKeyAndVisible()
                    }
                }
            }
        }
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
        
        UNUserNotificationCenter.current().getDeliveredNotifications { requests in
            UserDefaults.standard.set(requests.count, forKey: "bagdeNumber")
            DispatchQueue.main.async {
                UIApplication.shared.applicationIconBadgeNumber = requests.count
            }
        }
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        
        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
        
        UNUserNotificationCenter.current().getDeliveredNotifications { requests in
            UserDefaults.standard.set(requests.count, forKey: "bagdeNumber")
            DispatchQueue.main.async {
                UIApplication.shared.applicationIconBadgeNumber = requests.count
            }
        }
    }
    
    
}

