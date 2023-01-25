//
//  AppCoordinator.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 24.01.2023.
//

import ApphudSDK
import UIKit

final class AppCoordinator {
    enum Route: String {
        case recipe
    }
    
    let window: UIWindow?
    private let localDomainService: LocalDomainServiceInterface = LocalDomainService()
    private var rootNavigationController: UINavigationController?
    
    init(with window: UIWindow?) {
        self.window = window
    }
    
    func start() {
        var getStartedViewController: UIViewController
        if UDM.userData == nil {
            getStartedViewController = WelcomeRouter.setupModule()
        } else if Apphud.hasActiveSubscription() {
            getStartedViewController = CTTabBarController()
        } else {
            getStartedViewController = CTTabBarController()
//            getStartedViewController = PaywallRouter.setupModule()
        }
        
        let navigationController = UINavigationController(rootViewController: getStartedViewController)
        rootNavigationController = navigationController
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        updateHealthKitData()
        updateFoodData()
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundEffect = nil
        UINavigationBar.appearance().standardAppearance = appearance
    }
    
    private func updateFoodData() {
        DSF.shared.updateStoredDishes()
        DSF.shared.updateStoredProducts()
    }
    
    private func updateHealthKitData() {
        guard UDM.isAuthorisedHealthKit else { return }
        
        HealthKitDataManager.shared.getSteps { [weak self] steps in
            self?.localDomainService.saveSteps(data: steps)
        }
        
        HealthKitDataManager.shared.getWorkouts { [weak self] exercises  in
            self?.localDomainService.saveExercise(data: exercises)
        }
    }
    
    func navigateTo(route: Route?, with id: String) {
        guard let route = route else { return }
        switch route {
        case .recipe:
            if let dish = localDomainService.fetchSpecificRecipe(with: id),
               UDM.userData != nil {
                let recipeScreen = RecipePageScreenRouter.setupModule(with: dish, backButtonTitle: "Back".localized)
                recipeScreen.modalPresentationStyle = .fullScreen
                recipeScreen.modalTransitionStyle = .coverVertical
                rootNavigationController?.presentedViewController?.dismiss(animated: true)
                rootNavigationController?.present(recipeScreen, animated: true)
            }
        }
    }
}
