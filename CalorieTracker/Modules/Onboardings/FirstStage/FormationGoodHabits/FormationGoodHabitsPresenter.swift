//
//  FormationGoodHabitsPresenter.swift
//  CalorieTracker
//
//  Created by Алексей on 23.08.2022.
//

import Foundation

protocol FormationGoodHabitsPresenterInterface: AnyObject {
    func didTapContinueCommonButton()
}

class FormationGoodHabitsPresenter {
    
    unowned var view: FormationGoodHabitsViewControllerInterface
    let router: FormationGoodHabitsRouterInterface?
    let interactor: FormationGoodHabitsInteractorInterface?

    init(
        interactor: FormationGoodHabitsInteractorInterface,
        router: FormationGoodHabitsRouterInterface,
        view: FormationGoodHabitsViewControllerInterface
      ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension FormationGoodHabitsPresenter: FormationGoodHabitsPresenterInterface {
    func didTapContinueCommonButton() {
        router?.openThanksForTheInformation()
    }
}
