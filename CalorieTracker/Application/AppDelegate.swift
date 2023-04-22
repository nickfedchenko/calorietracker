//
//  AppDelegate.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 15.07.2022.
//

import Alamofire
import AdServices
import Amplitude
import ApphudSDK
import AsyncDisplayKit
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
        registerForNotifications()
        trackAppleSearchAds()
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
        UDM.currentlyWorkingDay = Date().day
        NotificationCenter.default.post(Notification(name: NSNotification.Name("UpdateMainScreen")))
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        coordinator.invalidateUpdateTimer()
        UDM.currentlyWorkingDay = Date().day
    }
    
    func registerForNotifications() {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { _, _ in
        }
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    private func trackAppleSearchAds() {
        if #available(iOS 14.3, *) {
            DispatchQueue.global(qos: .default).async {
                if let token = try? AAAttribution.attributionToken() {
                    DispatchQueue.main.async {
                        Apphud.addAttribution(data: nil, from: .appleAdsAttribution, identifer: token, callback: nil)
                    }
                }
            }
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Apphud.submitPushNotificationsToken(token: deviceToken, callback: nil)
        Amplitude.instance().logEvent("Successfully registered for remote notifications")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for push notifications")
        Amplitude.instance().logEvent("Failed to register remote notifications")
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        if Apphud.handlePushNotification(apsInfo: response.notification.request.content.userInfo) {
            // Push Notification was handled by Apphud, probably do nothing
            print("Handled succesfully")
        } else {
            // Handle other types of push notifications
            print("Need to manually handle push notification")
        }
        completionHandler()
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        if Apphud.handlePushNotification(apsInfo: notification.request.content.userInfo) {
            // Push Notification was handled by Apphud, probably do nothing
            print("Handled succesfully")
        } else {
            // Handle other types of push notifications
            print("Need to manually handle push notification")
        }
        completionHandler([]) // return empty array to skip showing notification banner
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        UDM.currentlyWorkingDay = Date().day
    }
}
