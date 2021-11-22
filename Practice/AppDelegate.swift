//
//  AppDelegate.swift
//  Practice
//
//  Created by Jorge Palacio on 11/22/21.
//  Copyright © 2021 Personal. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        guard let controller: MainViewController = window?.rootViewController?.storyboard?.instantiateViewController() else {
            return true
        }
        let presenter = MainPresenter(repository: MoviesRepository())
        let navigationController = UINavigationController(rootViewController: controller)
        let wireframe = MainWireframe(navigationController: navigationController)
        presenter.wireframe = wireframe
        controller.presenter = presenter
        window?.rootViewController = navigationController
        return true
    }
}

