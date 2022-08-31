//
//  DifficultyChoosingLifestylePresenter.swift
//  CalorieTracker
//
//  Created by Алексей on 30.08.2022.
//

import Foundation

protocol DifficultyChoosingLifestylePresenterInterface: AnyObject {
    func didTapApprovalCommonButton()
    func didTapRejectionCommonButton()
}

class DifficultyChoosingLifestylePresenter {
    
    // MARK: - Public properties
    
    unowned var view: DifficultyChoosingLifestyleViewControllerInterface
    let router: DifficultyChoosingLifestyleRouterInterface?
    let interactor: DifficultyChoosingLifestyleInteractorInterface?

    // MARK: - Initialization
    
    init(
        interactor: DifficultyChoosingLifestyleInteractorInterface,
        router: DifficultyChoosingLifestyleRouterInterface,
        view: DifficultyChoosingLifestyleViewControllerInterface
      ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - DifficultyChoosingLifestylePresenterInterface

extension DifficultyChoosingLifestylePresenter: DifficultyChoosingLifestylePresenterInterface {
    func didTapApprovalCommonButton() {
        interactor?.set(difficultyChoosingLifestyle: true)
        router?.openInterestInUsingTechnology()
    }
    
    func didTapRejectionCommonButton() {
        interactor?.set(difficultyChoosingLifestyle: false)
        router?.openInterestInUsingTechnology()
    }
}
