//
//  RepresentationOfIncreasedActivityLevelsPresenter.swift
//  CalorieTracker
//
//  Created by Алексей on 30.08.2022.
//

import Foundation

protocol RepresentationOfIncreasedActivityLevelsPresenterInterface: AnyObject {
    func didTapApprovalCommonButton()
    func didTapRejectionCommonButton()
}

class RepresentationOfIncreasedActivityLevelsPresenter {
    
    // MARK: - Public properties
    
    unowned var view: RepresentationOfIncreasedActivityLevelsViewControllerInterface
    let router: RepresentationOfIncreasedActivityLevelsRouterInterface?
    let interactor: RepresentationOfIncreasedActivityLevelsInteractorInterface?

    // MARK: - Initialization
    
    init(
        interactor: RepresentationOfIncreasedActivityLevelsInteractorInterface,
        router: RepresentationOfIncreasedActivityLevelsRouterInterface,
        view: RepresentationOfIncreasedActivityLevelsViewControllerInterface
      ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - RepresentationOfIncreasedActivityLevelsPresenterInterface

extension RepresentationOfIncreasedActivityLevelsPresenter: RepresentationOfIncreasedActivityLevelsPresenterInterface {
    func didTapApprovalCommonButton() {
        interactor?.set(representationOfIncreasedActivityLevels: true)
        router?.openSequenceOfHabitFormation()
    }
    
    func didTapRejectionCommonButton() {
        interactor?.set(representationOfIncreasedActivityLevels: false)
        router?.openSequenceOfHabitFormation()
    }
}
