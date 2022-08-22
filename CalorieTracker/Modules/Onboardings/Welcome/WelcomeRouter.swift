//
//  WelcomeRouter.swift
//  CalorieTracker
//
//  Created by Алексей on 19.08.2022.
//

import Foundation

protocol WelcomeRouterInterface: AnyObject {
    func openQuestionOfLosingWeight()
}

class WelcomeRouter: NSObject {
    
    weak var presenter: WelcomePresenterInterface?
    
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
        interactor.presenter = presenter
        return vc
    }
}

extension WelcomeRouter: WelcomeRouterInterface {
    func openQuestionOfLosingWeight() {
//        navigationController?.pushViewController(QuestionOfLosingWeightViewController(), animated: true)
    }
}
