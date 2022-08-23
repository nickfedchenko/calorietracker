//
//  QuestionAboutTheChangeRouter.swift
//  CalorieTracker
//
//  Created by Алексей on 22.08.2022.
//

import Foundation
import UIKit

protocol QuestionAboutTheChangeRouterInterface: AnyObject {
    func openAchievingDifficultGoal()
}

class QuestionAboutTheChangeRouter: NSObject {
    
    weak var presenter: QuestionAboutTheChangePresenterInterface?
    weak var viewController: UIViewController?
    
    static func setupModule() -> QuestionAboutTheChangeViewController {
        let vc = QuestionAboutTheChangeViewController()
        let interactor = QuestionAboutTheChangeInteractor()
        let router = QuestionAboutTheChangeRouter()
        let presenter = QuestionAboutTheChangePresenter(
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

extension QuestionAboutTheChangeRouter: QuestionAboutTheChangeRouterInterface {
    func openAchievingDifficultGoal() {
        let achievingDifficultGoalRouter = AchievingDifficultGoalRouter.setupModule()
        
        viewController?.navigationController?.pushViewController(achievingDifficultGoalRouter, animated: true)
    }
}
