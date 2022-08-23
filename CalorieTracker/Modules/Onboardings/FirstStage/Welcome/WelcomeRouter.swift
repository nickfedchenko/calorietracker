//
//  WelcomeRouter.swift
//  CalorieTracker
//
//  Created by Алексей on 19.08.2022.
//

import UIKit

protocol WelcomeRouterInterface: AnyObject {
    func openQuestionOfLosingWeight()
}

class WelcomeRouter: NSObject {
    
    weak var presenter: WelcomePresenterInterface?
    weak var viewController: UIViewController?
    
    static func setupModule() -> WelcomeViewController {
        let vc = WelcomeViewController()
        let interactor = WelcomeInteractor()
        let router = WelcomeRouter()
        let presenter = WelcomePresenter(
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

extension WelcomeRouter: WelcomeRouterInterface {
    func openQuestionOfLosingWeight() {
        let questionOfLosingWeightViewController = QuestionOfLosingWeightRouter.setupModule()
        
        viewController?.navigationController?.pushViewController(questionOfLosingWeightViewController, animated: true)
    }
}
