//
//  FormationGoodHabitsPresenter.swift
//  CalorieTracker
//
//  Created by Алексей on 23.08.2022.
//

import Foundation

protocol FormationGoodHabitsPresenterInterface: AnyObject {
    func viewDidLoad()
    func didTapContinueCommonButton()
    func didSelectFormationGoodHabits(with index: Int)
    func didDeselectFormationGoodHabits()
}

class FormationGoodHabitsPresenter {
    
    unowned var view: FormationGoodHabitsViewControllerInterface
    let router: FormationGoodHabitsRouterInterface?
    let interactor: FormationGoodHabitsInteractorInterface?

    private var formationGoodHabits: [FormationGoodHabits] = []
    private var formationGoodHabitsIndex: Int?
    
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
    func viewDidLoad() {
        formationGoodHabits = interactor?.getAllFormationGoodHabits() ?? []
        
        view.set(formationGoodHabits: formationGoodHabits)
    }
    
    func didTapContinueCommonButton() {
        interactor?.set(formationGoodHabits: .logEveryMealBefore)
        router?.openThanksForTheInformation()
    }
    
    func didSelectFormationGoodHabits(with index: Int) {
        formationGoodHabitsIndex = index
    }
    
    func didDeselectFormationGoodHabits() {
        formationGoodHabitsIndex = nil
    }
}
