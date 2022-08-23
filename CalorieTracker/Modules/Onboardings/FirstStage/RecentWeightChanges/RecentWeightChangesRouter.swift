//
//  RecentWeightChangesRouter.swift
//  CalorieTracker
//
//  Created by Алексей on 21.08.2022.
//

import Foundation
import UIKit

protocol RecentWeightChangesRouterInterface: AnyObject {
    func openCallToAchieveGoal()
}

class RecentWeightChangesRouter: NSObject {
    
    weak var presenter: RecentWeightChangesPresenterInterface?
    weak var viewController: UIViewController?
    
    static func setupModule() -> RecentWeightChangesViewController {
        let vc = RecentWeightChangesViewController()
        let interactor = RecentWeightChangesInteractor()
        let router = RecentWeightChangesRouter()
        let presenter = RecentWeightChangesPresenter(
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

extension RecentWeightChangesRouter: RecentWeightChangesRouterInterface {
    func openCallToAchieveGoal() {
        let callToAchieveGoalRouter = CallToAchieveGoalRouter.setupModule()
        
        viewController?.navigationController?.pushViewController(callToAchieveGoalRouter, animated: true)
    }
}
