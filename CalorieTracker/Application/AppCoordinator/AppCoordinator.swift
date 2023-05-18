//
//  AppCoordinator.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 24.01.2023.
//

import Amplitude
import ApphudSDK
import FirebaseCore
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
        startApphud()
        setupAmplitude()
        updateLogStreak()
        startFirebase()
        var getStartedViewController: UIViewController
        //        let trueFlag = true
        //        guard !trueFlag else {
        //            getStartedViewController = CalorieTrackingViaKcalcRouter.setupModule()
        //            let navigationController = UINavigationController(rootViewController: getStartedViewController)
        //            window?.rootViewController = navigationController
        //            window?.makeKeyAndVisible()
        //            return
        //        }
        updateHealthKitData()
        updateFoodData()
        if UDM.userData == nil {
            getStartedViewController = WelcomeRouter.setupModule()
            //            getStartedViewController = ChooseDietaryPreferenceRouter.setupModule()
        } else {
            if Apphud.hasActiveSubscription() {
                getStartedViewController = CTTabBarController()
            } else {
                getStartedViewController = PaywallRouter.setupModule()
            }
        }
//#if DEBUG
//getStartedViewController = LandingRouter.setupModule()
//#endif
        checkIsPaid()
        let navigationController = UINavigationController(rootViewController: getStartedViewController)
        rootNavigationController = navigationController
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundEffect = nil
        UINavigationBar.appearance().standardAppearance = appearance
        LocalNotificationsManager.askPermission()
        #if DEBUG
//        UDM.didShowAskingOpinion = false
        #endif
    }
    
    private func startFirebase() {
        FirebaseApp.configure()
    }
    
    private func updateFoodData() {
        DSF.shared.resaveOldFoodData()
        if abs(Calendar.current.dateComponents([.day], from: Date(), to: UDM.lastBaseUpdateDay).day ?? 0) > 6 {
            DSF.shared.updateStoredDishes()
            DSF.shared.updateStoredProducts()
        }
    }
    
    private func updateHealthKitData() {
//        HealthKitAccessManager.shared.updateAuthorizationStatus()
//        guard UDM.isAuthorisedHealthKit else { return }
//        
//        HealthKitDataManager.shared.getSteps { [weak self] steps in
//            self?.localDomainService.saveSteps(data: steps)
//        }
//        
//        HealthKitDataManager.shared.getWorkouts { [weak self] exercises  in
//            self?.localDomainService.saveExercise(data: exercises)
//        }
//        
//        HealthKitDataManager.shared.getBurnedKcal { [weak self] burnedKCal in
//            self?.localDomainService.saveBurnedKcal(data: burnedKCal)
//        }
//        
//        setupPeriodicUpdate()
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
    
    private func updateLogStreak() {
        let streak = CalendarWidgetService.shared.getStreakDays()
        LoggingService.postEvent(event: .caldaysstreak(count: streak))
    }
    
    func navigateTo(route: Route?, with id: String) {
        guard let route = route else { return }
//        let finalOnb = CalorieTrackingViaKcalcRouter.setupModule()
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
        hkUpdateTimer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { _ in
            
            HealthKitDataManager.shared.getSteps { [weak self] steps in
                self?.localDomainService.saveSteps(data: steps)
            }
            
            HealthKitDataManager.shared.getWorkouts { [weak self] exercises  in
                self?.localDomainService.saveExercise(data: exercises)
            }
            
            HealthKitDataManager.shared.getBurnedKcal { [weak self] burnedKcalData in
                self?.localDomainService.saveBurnedKcal(data: burnedKcalData)
            }
            
            HealthKitDataManager.shared.getWeights { [weak self] data in
                self?.localDomainService.saveWeight(data: data)
            }
        }
    }
    
    func invalidateUpdateTimer() {
        hkUpdateTimer?.invalidate()
    }
    
    func checkIsPaid() {
        Amplitude.instance().setUserProperties(["isPaid": Apphud.hasActiveSubscription()])
    }
}
