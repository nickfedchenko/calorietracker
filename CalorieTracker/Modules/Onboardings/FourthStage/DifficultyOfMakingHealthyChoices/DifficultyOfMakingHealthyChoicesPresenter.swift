//
//  DifficultyOfMakingHealthyChoicesPresenter.swift
//  CalorieTracker
//
//  Created by Алексей on 31.08.2022.
//

import Foundation

protocol DifficultyOfMakingHealthyChoicesPresenterInterface: AnyObject {
    func viewDidLoad()
    func didTapContinueCommonButton()
}

class DifficultyOfMakingHealthyChoicesPresenter {
    
    // MARK: - Public properties

    unowned var view: DifficultyOfMakingHealthyChoicesViewControllerInterface
    let router: DifficultyOfMakingHealthyChoicesRouterInterface?
    let interactor: DifficultyOfMakingHealthyChoicesInteractorInterface?

    // MARK: - Initialization
    
    init(
        interactor: DifficultyOfMakingHealthyChoicesInteractorInterface,
        router: DifficultyOfMakingHealthyChoicesRouterInterface,
        view: DifficultyOfMakingHealthyChoicesViewControllerInterface
      ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension DifficultyOfMakingHealthyChoicesPresenter: DifficultyOfMakingHealthyChoicesPresenterInterface {
    func viewDidLoad() {
        if let currentOnboardingStage = interactor?.getCurrentOnboardingStage() {
            view.set(currentOnboardingStage: currentOnboardingStage)
        }
    }
    
    func didTapContinueCommonButton() {
        router?.openLifestyleOfOthers()
    }
}