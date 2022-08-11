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
import Alamofire

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
        NetworkEngine.shared.fetchDishes { result in
            
            switch result {
            case .success(let dishes):
                print(dishes.first)
            case .failure(let error):
                if case let .AFError(error: aFerror) = error {
                    dump(aFerror)
                }
            }
        }
        return true
    }
}
