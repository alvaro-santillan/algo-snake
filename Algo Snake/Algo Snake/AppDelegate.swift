//
//  AppDelegate.swift
//  Snake
//
//  Created by Álvaro Santillan on 1/8/20.
//  Copyright © 2020 Álvaro Santillan. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let defaultValue = ["highScore" : 0]
        UserDefaults.standard.register(defaults: defaultValue)
        UserDefaults.standard.set(0, forKey: "Selected Path Finding Algorithim")
        UserDefaults.standard.set(0, forKey: "Selected Maze Algorithim")
        UserDefaults.standard.set("Player", forKey: "Selected Path Finding Algorithim Name")
        UserDefaults.standard.set("None", forKey: "Selected Maze Algorithim Name")
        UserDefaults.standard.set(true, forKey: "Game Is Paused Setting")
        return true
    }

    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    func applicationWillResignActive(_ application: UIApplication) {
        UserDefaults.standard.set(true, forKey: "Game Is Paused Setting")
    }

    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    func applicationDidEnterBackground(_ application: UIApplication) {
        UserDefaults.standard.set(true, forKey: "Game Is Paused Setting")
    }

    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    func applicationWillEnterForeground(_ application: UIApplication) {
        UserDefaults.standard.set(true, forKey: "Game Is Paused Setting")
    }

    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    func applicationDidBecomeActive(_ application: UIApplication) {
        UserDefaults.standard.set(true, forKey: "Game Is Paused Setting")
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        UserDefaults.standard.set(0, forKey: "Selected Path Finding Algorithim")
        UserDefaults.standard.set(0, forKey: "Selected Maze Algorithim")
        UserDefaults.standard.set(true, forKey: "Game Is Paused Setting")
    }
}
