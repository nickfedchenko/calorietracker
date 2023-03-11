//
//  AppDelegate.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 15.07.2022.
//

import Alamofire
import ApphudSDK
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

    lazy var coordinator = AppCoordinator(with: window)
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        coordinator.start()
        return true
    }
    
    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey: Any] = [:]
    ) -> Bool {
                if let scheme = url.scheme,
                        scheme.localizedCaseInsensitiveCompare("com.Calorie.Tracker") == .orderedSame,
                        let view = url.host,
                   let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
                   let id = components.queryItems?.first?.value,
                   let route = AppCoordinator.Route(rawValue: view) {
                    coordinator.navigateTo(route: route, with: id)
                } else {
                    print("Something goes wrong")
                }
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        coordinator.setupPeriodicUpdate()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        coordinator.invalidateUpdateTimer()
    }
}
