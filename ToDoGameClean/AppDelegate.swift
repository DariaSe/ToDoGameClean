//
//  AppDelegate.swift
//  ToDoGameClean
//
//  Created by Дарья Селезнёва on 11.03.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        let viewController = TaskListViewController()
        TaskListConfigurator.shared.configure(viewController: viewController)
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
        return true
    }
}

