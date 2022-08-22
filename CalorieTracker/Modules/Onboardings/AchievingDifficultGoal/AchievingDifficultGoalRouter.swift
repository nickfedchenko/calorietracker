//
//  AchievingDifficultGoalRouter.swift
//  CalorieTracker
//
//  Created by Алексей on 22.08.2022.
//

import Foundation

protocol AchievingDifficultGoalRouterInterface: AnyObject {
    func openAchievementByWillpower()
}

class AchievingDifficultGoalRouter: NSObject {
    
    weak var presenter: AchievingDifficultGoalPresenterInterface?
    
    static func setupModule() -> AchievingDifficultGoalViewController {
        let vc = AchievingDifficultGoalViewController()
        let interactor = AchievingDifficultGoalInteractor()
        let router = AchievingDifficultGoalRouter()
        let presenter = AchievingDifficultGoalPresenter(
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

extension AchievingDifficultGoalRouter: AchievingDifficultGoalRouterInterface {
    func openAchievementByWillpower() {}
}
