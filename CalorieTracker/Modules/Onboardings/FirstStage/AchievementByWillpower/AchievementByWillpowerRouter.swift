//
//  AchievementByWillpowerRouter.swift
//  CalorieTracker
//
//  Created by Алексей on 22.08.2022.
//

import Foundation
import UIKit

protocol AchievementByWillPowerRouterInterface: AnyObject {
    func openLastCalorieCount ()
}

class AchievementByWillPowerRouter: NSObject {
    
    // MARK: - Public properties
    
    weak var presenter: AchievementByWillPowerPresenterInterface?
    weak var viewController: UIViewController?
    
    // MARK: - Static methods
    
    static func setupModule() -> AchievementByWillPowerViewController {
        let vc = AchievementByWillPowerViewController()
        let interactor = AchievementByWillPowerInteractor()
        let router = AchievementByWillPowerRouter()
        let presenter = AchievementByWillPowerPresenter(
            interactor: interactor,
            router: router,
            view: vc
        )

        vc.presenter = presenter
        router.presenter = presenter
        router.viewController = vc
        interactor.presenter = presenter
        return vc
    }
}

// MARK: - AchievementByWillPowerRouterInterface

extension AchievementByWillPowerRouter: AchievementByWillPowerRouterInterface {
    func openLastCalorieCount() {
        let lastCalorieCountRouter = LastCalorieCountRouter.setupModule()
        
        viewController?.navigationController?.pushViewController(lastCalorieCountRouter, animated: true)
    }
}
