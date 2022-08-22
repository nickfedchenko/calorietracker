//
//  CallToAchieveGoalRouter.swift
//  CalorieTracker
//
//  Created by Алексей on 22.08.2022.
//

import Foundation

protocol CallToAchieveGoalRouterInterface: AnyObject {
    func openQuestionAboutTheChange()
}

class CallToAchieveGoalRouter: NSObject {
    
    weak var presenter: CallToAchieveGoalPresenterInterface?
    
    static func setupModule() -> CallToAchieveGoalViewController {
        let vc = CallToAchieveGoalViewController()
        let interactor = CallToAchieveGoalInteractor()
        let router = CallToAchieveGoalRouter()
        let presenter = CallToAchieveGoalPresenter(
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

extension CallToAchieveGoalRouter: CallToAchieveGoalRouterInterface {
    func openQuestionAboutTheChange() {}
}
