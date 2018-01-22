//
//  AppDelegate.swift
//  BookingComponent
//
//  Created by Pavel Mosunov on 1/16/18.
//  Copyright © 2018 Anoda. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()
    
        let bookingVC = BookingVC(TestDataGenerator.createVendor(), .haircut, TestDataGenerator.createClinet(id: 17))
        window?.rootViewController = UINavigationController.init(rootViewController: bookingVC)
        
        return true
    }

}

