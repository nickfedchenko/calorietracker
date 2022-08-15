//
//  AppDelegate.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 15.07.2022.
//
import Alamofire
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
        let tabBar = CTTabBarController()
        window?.rootViewController = tabBar
        window?.makeKeyAndVisible()
        var now = Date().timeIntervalSince1970
//        DSF.shared.updateStoredDishes()
        DSF.shared.updateStoredProducts()
        DispatchQueue.main.async {
            var dishes = DSF.shared.getAllStoredProducts()
             while dishes.isEmpty {
                dishes = DSF.shared.getAllStoredProducts()
            }
            print("Time elapsed = \(Date().timeIntervalSince1970 - now)")
            print(dishes.count)
            print(dishes[4])
        }
        return true
    }
}
