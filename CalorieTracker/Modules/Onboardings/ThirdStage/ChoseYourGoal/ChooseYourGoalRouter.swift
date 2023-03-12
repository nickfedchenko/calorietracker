//
//  ChooseYourGoalRouter.swift
//  CIViperGenerator
//
//  Created by Alexandru Jdanov on 11.03.2023.
//  Copyright © 2023 Alexandru Jdanov. All rights reserved.
//

import Foundation
import UIKit

protocol ChooseYourGoalRouterInterface: AnyObject {
    func openLifeChangesAfterWeightLoss()
}

class ChooseYourGoalRouter: NSObject {

    weak var presenter: ChoseYourGoalPresenterInterface?
    weak var viewController: UIViewController?

    static func setupModule() -> ChoseYourGoalViewController {
        let vc = ChoseYourGoalViewController()
        let interactor = ChoseYourGoalInteractor(onboardingManager: OnboardingManager.shared)
        let router = ChooseYourGoalRouter()
        let presenter = ChoseYourGoalPresenter(interactor: interactor, router: router, view: vc)

        vc.presenter = presenter
        router.presenter = presenter
        router.viewController = vc
        interactor.presenter = presenter
        return vc
    }
}

extension ChooseYourGoalRouter: ChooseYourGoalRouterInterface {
    func openLifeChangesAfterWeightLoss() {
        let lifeChangesAfterWeightLossRouter = LifeChangesAfterWeightLossRouter.setupModule()
        
        viewController?.navigationController?.pushViewController(lifeChangesAfterWeightLossRouter, animated: true)
    }
}
