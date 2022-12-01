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
        
        let getStartedViewController = CTTabBarController()
        let navigationController = UINavigationController(rootViewController: getStartedViewController)
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        DSF.shared.updateStoredDishes()
        DSF.shared.updateStoredProducts()
        
        //generateFakeUserData()
        
        return true
    }
    
    
    // Создает данные юзера (Рандомно) позже удалить
    private func generateFakeUserData() {
        let products = Array(DSF.shared.getAllStoredProducts()[10...30])

        products.forEach {
            let foodData = FoodData(
                dateLastUse: Date(),
                favorites: Bool.random(),
                numberUses: Int.random(in: 0...5)
            )

            LocalDomainService().saveFoodData(foods: [foodData])

            foodData.setChild($0)
        }
    }
    
}
