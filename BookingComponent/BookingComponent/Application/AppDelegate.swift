//
//  AppDelegate.swift
//  BookingComponent
//
//  Created by Pavel Mosunov on 1/16/18.
//  Copyright © 2018 ANODA. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()
    
        window?.rootViewController = UINavigationController.init(rootViewController: StartVC())
        
        print(UIFont.familyNames)
        let nameString = "SF Pro Text"
        for name in UIFont.familyNames {
            print(name)
            if nameString == name
            {
                print(UIFont.fontNames(forFamilyName: nameString))
            }
        }
        
        Fabric.with([Crashlytics.self])
        
        return true
    }

}

