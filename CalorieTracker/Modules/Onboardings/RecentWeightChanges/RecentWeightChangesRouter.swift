//
//  RecentWeightChangesRouter.swift
//  CalorieTracker
//
//  Created by Алексей on 21.08.2022.
//

import Foundation

protocol RecentWeightChangesRouterInterface: AnyObject {
    func openCallToAchieveGoal()
}

class RecentWeightChangesRouter: NSObject {
    
    weak var presenter: RecentWeightChangesPresenterInterface?
    
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
        interactor.presenter = presenter
        return vc
    }
}

extension RecentWeightChangesRouter: RecentWeightChangesRouterInterface {
    func openCallToAchieveGoal() {}
}
