//
//  FormationGoodHabitsRouter.swift
//  CalorieTracker
//
//  Created by Алексей on 23.08.2022.
//

import Foundation

protocol FormationGoodHabitsRouterInterface: AnyObject {
    func openThanksForTheInformation()
}

class FormationGoodHabitsRouter: NSObject {
    
    weak var presenter: FormationGoodHabitsPresenterInterface?
    
    static func setupModule() -> FormationGoodHabitsViewController {
        let vc = FormationGoodHabitsViewController()
        let interactor = FormationGoodHabitsInteractor()
        let router = FormationGoodHabitsRouter()
        let presenter = FormationGoodHabitsPresenter(
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

extension FormationGoodHabitsRouter: FormationGoodHabitsRouterInterface {
    func openThanksForTheInformation() {}
}
