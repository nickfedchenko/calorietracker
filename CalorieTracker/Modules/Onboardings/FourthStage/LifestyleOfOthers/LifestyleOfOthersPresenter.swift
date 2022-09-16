//
//  LifestyleOfOthersPresenter.swift
//  CalorieTracker
//
//  Created by Алексей on 31.08.2022.
//

import Foundation

protocol LifestyleOfOthersPresenterInterface: AnyObject {
    func viewDidLoad()
    func didTapContinueCommonButton()
}

class LifestyleOfOthersPresenter {
    
    // MARK: - Public properties

    unowned var view: LifestyleOfOthersViewControllerInterface
    let router: LifestyleOfOthersRouterInterface?
    let interactor: LifestyleOfOthersInteractorInterface?
    
    // MARK: - Private properties

    private var lifestyleOfOthers: [LifestyleOfOthers] = []

    // MARK: - Initialization
    
    init(
        interactor: LifestyleOfOthersInteractorInterface,
        router: LifestyleOfOthersRouterInterface,
        view: LifestyleOfOthersViewControllerInterface
      ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - LifestyleOfOthersPresenterInterface

extension LifestyleOfOthersPresenter: LifestyleOfOthersPresenterInterface {
    func viewDidLoad() {
        lifestyleOfOthers = interactor?.getAllLifestyleOfOthers() ?? []
        
        view.set(lifestyleOfOthers: lifestyleOfOthers)
        
        if let currentOnboardingStage = interactor?.getCurrentOnboardingStage() {
            view.set(currentOnboardingStage: currentOnboardingStage)
        }
    }
    
    func didTapContinueCommonButton() {
        interactor?.set(lifestyleOfOthers: .dontHaveManyHealthyHabitsount)
        router?.openEmotionalSupportSystem()
    }
}
