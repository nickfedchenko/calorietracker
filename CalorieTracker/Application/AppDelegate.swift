//
//  AppDelegate.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 15.07.2022.
//

import AsyncDisplayKit
import Firebase
import Gzip
import Kingfisher
import Lottie
import SnapKit
import Swinject
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = MainScreenViewController()
        window?.makeKeyAndVisible()
        return true
    }
}
