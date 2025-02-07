//
//  AppDelegate.swift
//  DiseaseDict
//
//  Created by Currie on 11/22/20.
//  Copyright © 2020 Currie. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift
import GoogleMobileAds

@available(iOS 13.0, *)
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        if Reachability.isConnectedToNetwork() {
            print("Network OK")
        } else {
            print("Network Fail")
        }

        
        // set the delegate in didFinishLaunchingWithOptions
        UNUserNotificationCenter.current().delegate = self
        UIApplication.shared.delegate = self
        
        let config = Realm.Configuration(
          // Set the new schema version. This must be greater than the previously used
          // version (if you've never set a schema version before, the version is 0).
          schemaVersion: 1,

          // Set the block which will be called automatically when opening a Realm with
          // a schema version lower than the one set above
          migrationBlock: { migration, oldSchemaVersion in
            // We haven’t migrated anything yet, so oldSchemaVersion == 0
            if (oldSchemaVersion < 1) {
              // Nothing to do!
              // Realm will automatically detect new properties and removed properties
              // And will update the schema on disk automatically
            }
          })

        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [ "17d8f5a86914f2e4dd8676d1ea8bdfdc", kGADSimulatorID as! String ]
        GADRequestConfiguration().testDeviceIdentifiers = ["17d8f5a86914f2e4dd8676d1ea8bdfdc", kGADSimulatorID as! String]
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
//    func applicationDidEnterBackground(_ application: UIApplication) {
//        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
//            UserDefaults.standard.set(requests.count, forKey: "bagdeNumber")
//            print(requests.count)
//            application.applicationIconBadgeNumber = requests.count
//        }
//    }
//    
//    func applicationWillEnterForeground(_ application: UIApplication) {
//        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
//            UserDefaults.standard.set(requests.count, forKey: "bagdeNumber")
//            print(requests.count)
//            application.applicationIconBadgeNumber = requests.count
//        }
//    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert,.badge,.sound])
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentCloudKitContainer(name: "DiseaseDict")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

