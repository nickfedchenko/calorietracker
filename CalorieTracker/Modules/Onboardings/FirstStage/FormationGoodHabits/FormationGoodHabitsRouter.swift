//
//  FormationGoodHabitsRouter.swift
//  CalorieTracker
//
//  Created by Алексей on 23.08.2022.
//

import Foundation
import UIKit

protocol FormationGoodHabitsRouterInterface: AnyObject {
    func openThanksForTheInformation()
}

class FormationGoodHabitsRouter: NSObject {
    
    weak var presenter: FormationGoodHabitsPresenterInterface?
    weak var viewController: UIViewController?
    
    static func setupModule() -> FormationGoodHabitsViewController {
        let vc = FormationGoodHabitsViewController()
        let interactor = FormationGoodHabitsInteractor(onboardingManager: OnboardingManager.shared)
        let router = FormationGoodHabitsRouter()
        let presenter = FormationGoodHabitsPresenter(
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

extension FormationGoodHabitsRouter: FormationGoodHabitsRouterInterface {
    func openThanksForTheInformation() {
        let thanksForTheInformationRouter = ThanksForTheInformationRouter.setupModule()
        
        viewController?.navigationController?.pushViewController(thanksForTheInformationRouter, animated: true)
    }
}
