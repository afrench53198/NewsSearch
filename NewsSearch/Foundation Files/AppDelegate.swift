//
//  AppDelegate.swift
//  NewsSearch
//
//  Created by Adam B French on 10/15/17.
//  Copyright © 2017 Adam B French. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var key: String? {
        if let path = Bundle.main.path(forResource: "Keys", ofType: "plist") {
            let key = NSDictionary(contentsOfFile: path)
            if let dict = key {
                return dict["apiKey"] as! String
            }
        }
        print("App Delegate couldn't parse Key from Dictionary")
        return nil 
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        var appearance = UINavigationBar.appearance()
        appearance.tintColor = .white
        appearance.barTintColor = .black
        let key = NSAttributedStringKey.foregroundColor
        appearance.titleTextAttributes = [ key:UIColor.white]
        var segControlAppearance = UISegmentedControl.appearance()
        segControlAppearance.apportionsSegmentWidthsByContent = true
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

