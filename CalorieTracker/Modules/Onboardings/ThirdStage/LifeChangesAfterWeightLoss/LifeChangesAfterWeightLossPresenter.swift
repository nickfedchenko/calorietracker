//
//  LifeChangesAfterWeightLossPresenter.swift
//  CalorieTracker
//
//  Created by Алексей on 29.08.2022.
//

import Foundation

protocol LifeChangesAfterWeightLossPresenterInterface: AnyObject {
    func viewDidLoad()
    func didTapContinueCommonButton()
}

class LifeChangesAfterWeightLossPresenter {
    
    // MARK: - Public properties

    unowned var view: LifeChangesAfterWeightLossViewControllerInterface
    let router: LifeChangesAfterWeightLossRouterInterface?
    let interactor: LifeChangesAfterWeightLossInteractorInterface?
    
    // MARK: - Private properties

    private var lifeChangesAfterWeightLoss: [LifeChangesAfterWeightLoss] = []

    // MARK: - Initialization
    
    init(
        interactor: LifeChangesAfterWeightLossInteractorInterface,
        router: LifeChangesAfterWeightLossRouterInterface,
        view: LifeChangesAfterWeightLossViewControllerInterface
      ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - LifeChangesAfterWeightLossPresenterInterface

extension LifeChangesAfterWeightLossPresenter: LifeChangesAfterWeightLossPresenterInterface {
    func viewDidLoad() {
        lifeChangesAfterWeightLoss = interactor?.getAllLifeChangesAfterWeightLoss() ?? []
        
        view.set(lifeChangesAfterWeightLoss: lifeChangesAfterWeightLoss)
        
        if let currentOnboardingStage = interactor?.getCurrentOnboardingStage() {
            view.set(currentOnboardingStage: currentOnboardingStage)
        }
    }
    
    func didTapContinueCommonButton() {
        interactor?.set(lifeChangesAfterWeightLoss: .feelingGreat)
        router?.openReflectToAchievedSomethingDifficult()
    }
}
