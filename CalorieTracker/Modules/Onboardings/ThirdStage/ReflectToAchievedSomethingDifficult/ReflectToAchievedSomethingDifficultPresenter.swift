//
//  ReflectToAchievedSomethingDifficultPresenter.swift
//  CalorieTracker
//
//  Created by Алексей on 29.08.2022.
//

import Foundation

protocol ReflectToAchievedSomethingDifficultPresenterInterface: AnyObject {
    func viewDidLoad()
    func didTapContinueCommonButton()
}

class ReflectToAchievedSomethingDifficultPresenter {
    
    // MARK: - Public properties

    unowned var view: ReflectToAchievedSomethingDifficultViewControllerInterface
    let router: ReflectToAchievedSomethingDifficultRouterInterface?
    let interactor: ReflectToAchievedSomethingDifficultInteractorInterface?

    // MARK: - Initialization
    
    init(
        interactor: ReflectToAchievedSomethingDifficultInteractorInterface,
        router: ReflectToAchievedSomethingDifficultRouterInterface,
        view: ReflectToAchievedSomethingDifficultViewControllerInterface
      ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - ReflectToAchievedSomethingDifficultPresenterInterface

extension ReflectToAchievedSomethingDifficultPresenter: ReflectToAchievedSomethingDifficultPresenterInterface {
    func viewDidLoad() {
        if let currentOnboardingStage = interactor?.getCurrentOnboardingStage() {
            view.set(currentOnboardingStage: currentOnboardingStage)
        }
    }
    
    func didTapContinueCommonButton() {
        router?.openTimeToSeeYourGoalWeight()
    }
}
