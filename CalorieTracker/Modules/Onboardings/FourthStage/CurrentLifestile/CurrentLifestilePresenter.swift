//
//  CurrentLifestilePresenter.swift
//  CalorieTracker
//
//  Created by Алексей on 29.08.2022.
//

import Foundation

protocol CurrentLifestilePresenterInterface: AnyObject {
    func viewDidLoad()
    func didTapContinueCommonButton()
}

class CurrentLifestilePresenter {
    
    // MARK: - Public properties

    unowned var view: CurrentLifestileViewControllerInterface
    let router: CurrentLifestileRouterInterface?
    let interactor: CurrentLifestileInteractorInterface?
    
    // MARK: - Private properties

    private var currentLifestile: [CurrentLifestile] = []

    // MARK: - Initialization
    
    init(
        interactor: CurrentLifestileInteractorInterface,
        router: CurrentLifestileRouterInterface,
        view: CurrentLifestileViewControllerInterface
      ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - CurrentLifestilePresenterInterface

extension CurrentLifestilePresenter: CurrentLifestilePresenterInterface {
    func viewDidLoad() {
        currentLifestile = interactor?.getAllCurrentLifestile() ?? []
        
        view.set(currentLifestile: currentLifestile)
    }
    
    func didTapContinueCommonButton() {
        interactor?.set(currentLifestile: .myDietAndActivityNeedImprovement)
        router?.openNutritionImprovement()
    }
}
