//
//  AppDelegate.swift
//  TuristV
//
//  Created by Pablo Perez Zeballos on 10/16/20.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  
  var window: UIWindow?
  let dataController = DataController(modelName: "Tourist")

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    
    return true
  }

  
  func applicationDidEnterBackground(_ application: UIApplication) {

  }

  func applicationWillTerminate(_ application: UIApplication) {
      // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }
}

