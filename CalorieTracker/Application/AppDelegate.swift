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
        DSF.shared.updateStoredDishes()
        DSF.shared.updateStoredProducts()
        
        // TODO: После ревью удалить
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let products = DSF.shared.getAllStoredProducts()
            let dishes = DSF.shared.getAllStoredDishes()
            print("received products count is \(products.count)")
            print("received dishes count is \(dishes.count)")
        }
        return true
    }
    
}
