//
//  AppCoordinator.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 24.01.2023.
//

import ApphudSDK
import Amplitude
import UIKit

final class AppCoordinator: ApphudDelegate {
    enum Route: String {
        case recipe
    }
    
    let window: UIWindow?
    private let localDomainService: LocalDomainServiceInterface = LocalDomainService()
    private var rootNavigationController: UINavigationController?
    var hkUpdateTimer: Timer?
    
    init(with window: UIWindow?) {
        self.window = window
    }
    
    func start() {
        UDM.currentlyWorkingDay = Day(Date())
        var getStartedViewController: UIViewController
        //        let trueFlag = true
        //        guard !trueFlag else {
        //            getStartedViewController = CalorieTrackingViaKcalcRouter.setupModule()
        //            let navigationController = UINavigationController(rootViewController: getStartedViewController)
        //            window?.rootViewController = navigationController
        //            window?.makeKeyAndVisible()
        //            return
        //        }
        
        if UDM.userData == nil {
            getStartedViewController = WelcomeRouter.setupModule()
            //            getStartedViewController = ChooseDietaryPreferenceRouter.setupModule()
        } else if Apphud.hasActiveSubscription() {
            getStartedViewController = CTTabBarController()
            //            getStartedViewController = PaywallRouter.setupModule()
        } else {
            //            getStartedViewController = CTTabBarController()
            getStartedViewController = PaywallRouter.setupModule()
            //            getStartedViewController = RateUsScreenRouter.setupModule()
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
        #if DEBUG
        UDM.didShowAskingOpinion = false
        #endif
        startApphud()
        setupAmplitude()
    }
    
    private func updateFoodData() {
        DSF.shared.updateStoredDishes()
        DSF.shared.updateStoredProducts()
    }
    
    private func updateHealthKitData() {
        HealthKitAccessManager.shared.updateAuthorizationStatus()
        guard UDM.isAuthorisedHealthKit else { return }
        
        HealthKitDataManager.shared.getSteps { [weak self] steps in
            self?.localDomainService.saveSteps(data: steps)
        }
        
        HealthKitDataManager.shared.getWorkouts { [weak self] exercises  in
            self?.localDomainService.saveExercise(data: exercises)
        }
        
        setupPeriodicUpdate()
    }
    
    private func startApphud() {
        Apphud.start(apiKey: "app_HW3PbpkqD1jPNEfhdgrRyRyiAmwWB9")
        Apphud.setDelegate(self)
    }
    
    private func setupAmplitude() {
        Amplitude.instance().trackingSessionEvents = true
        Amplitude.instance().initializeApiKey("a3f37803a6c4e1da9f884f40d47236d7", userId: Apphud.userID())
        Amplitude.instance().logEvent("app_start")
    }
    
    func navigateTo(route: Route?, with id: String) {
        guard let route = route else { return }
        let finalOnb = CalorieTrackingViaKcalcRouter.setupModule()
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
    
    func apphudDidChangeUserID(_ userID: String) {
        Amplitude.instance().setUserId(userID)
    }
    
    func setupPeriodicUpdate() {
        hkUpdateTimer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { timer in
            HealthKitDataManager.shared.getSteps { [weak self] steps in
                self?.localDomainService.saveSteps(data: steps)
            }
            
            HealthKitDataManager.shared.getWorkouts { [weak self] exercises  in
                self?.localDomainService.saveExercise(data: exercises)
            }
            
            HealthKitDataManager.shared.getBurnedKcal { data in
                print(data)
            }
        }
    }
    
    func invalidateUpdateTimer() {
        hkUpdateTimer?.invalidate()
    }
}
