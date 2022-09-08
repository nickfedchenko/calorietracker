//
//  CallToAchieveGoalPresenter.swift
//  CalorieTracker
//
//  Created by Алексей on 22.08.2022.
//

import Foundation

protocol CallToAchieveGoalPresenterInterface: AnyObject {
    func viewDidLoad()
    func didTapContinueCommonButton()
}

class CallToAchieveGoalPresenter {
    
    // MARK: - Public properties
    
    unowned var view: CallToAchieveGoalViewControllerInterface
    let router: CallToAchieveGoalRouterInterface?
    let interactor: CallToAchieveGoalInteractorInterface?

    // MARK: - Initialization
    
    init(
        interactor: CallToAchieveGoalInteractorInterface,
        router: CallToAchieveGoalRouterInterface,
        view: CallToAchieveGoalViewControllerInterface
      ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - CallToAchieveGoalPresenterInterface

extension CallToAchieveGoalPresenter: CallToAchieveGoalPresenterInterface {
    func viewDidLoad() {
        if let currentOnboardingStage = interactor?.getCurrentOnboardingStage() {
            view.set(currentOnboardingStage: currentOnboardingStage)
        }
    }
    
    func didTapContinueCommonButton() {
        router?.openQuestionAboutTheChange()
    }
}
