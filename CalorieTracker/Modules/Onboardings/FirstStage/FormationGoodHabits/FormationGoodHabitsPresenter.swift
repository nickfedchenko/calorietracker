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
    
    // MARK: - Public properties

    unowned var view: FormationGoodHabitsViewControllerInterface
    let router: FormationGoodHabitsRouterInterface?
    let interactor: FormationGoodHabitsInteractorInterface?

    // MARK: - Private properties

    private var formationGoodHabits: [FormationGoodHabits] = []
    private var formationGoodHabitsIndex: Int?
    
    // MARK: - Initialization

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

// MARK: - FormationGoodHabitsPresenterInterface

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
