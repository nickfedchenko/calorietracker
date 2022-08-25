//
//  CallToAchieveGoalRouter.swift
//  CalorieTracker
//
//  Created by Алексей on 22.08.2022.
//

import Foundation
import UIKit

protocol CallToAchieveGoalRouterInterface: AnyObject {
    func openQuestionAboutTheChange()
}

class CallToAchieveGoalRouter: NSObject {
    
    // MARK: - Public properties
    
    weak var presenter: CallToAchieveGoalPresenterInterface?
    weak var viewController: UIViewController?
    
    // MARK: - Static methods
    
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
        router.viewController = vc
        interactor.presenter = presenter
        return vc
    }
}

// MARK: - CallToAchieveGoalRouterInterface

extension CallToAchieveGoalRouter: CallToAchieveGoalRouterInterface {
    func openQuestionAboutTheChange() {
        let questionAboutTheChangeRouter = QuestionAboutTheChangeRouter.setupModule()
        
        viewController?.navigationController?.pushViewController(questionAboutTheChangeRouter, animated: true)
    }
}
