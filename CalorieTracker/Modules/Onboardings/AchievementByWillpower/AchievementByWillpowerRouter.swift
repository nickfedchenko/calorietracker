//
//  AchievementByWillpowerRouter.swift
//  CalorieTracker
//
//  Created by Алексей on 22.08.2022.
//

import Foundation

protocol AchievementByWillPowerRouterInterface: AnyObject {
    func openLastCalorieCount ()
}

class AchievementByWillPowerRouter: NSObject {
    
    weak var presenter: AchievementByWillPowerPresenterInterface?
    
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
        interactor.presenter = presenter
        return vc
    }
}

extension AchievementByWillPowerRouter: AchievementByWillPowerRouterInterface {
    func openLastCalorieCount() {}
}
