//
//  AppDelegate.swift
//  LedController
//
//  Created by Philipp Wallrich on 02.09.18.
//  Copyright © 2018 Philipp Wallrich. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        SocketIOManager.shared.closeConnection()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        SocketIOManager.shared.establishConnnection()
    }

}

