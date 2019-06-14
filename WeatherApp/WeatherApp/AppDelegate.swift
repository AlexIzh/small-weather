//
//  AppDelegate.swift
//  WeatherApp
//
//  Created by Alex Severyanov on 6/12/19.
//  Copyright © 2019 Alex Severyanov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

   lazy var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
   let coordinator = MainCoordinator()

   func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
      window?.rootViewController = coordinator.instantiateInitialController()
      window?.makeKeyAndVisible()
      return true
   }
}

