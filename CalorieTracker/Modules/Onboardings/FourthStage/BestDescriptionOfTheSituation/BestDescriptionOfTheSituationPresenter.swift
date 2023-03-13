//
//  BestDescriptionOfTheSituationPresenter.swift
//  CalorieTracker
//
//  Created by Алексей on 31.08.2022.
//

import Foundation

protocol BestDescriptionOfTheSituationPresenterInterface: AnyObject {
    func viewDidLoad()
    func didTapContinueCommonButton()
}

class BestDescriptionOfTheSituationPresenter {
    
    // MARK: - Public properties

    unowned var view: BestDescriptionOfTheSituationViewControllerInterface
    let router: BestDescriptionOfTheSituationRouterInterface?
    let interactor: BestDescriptionOfTheSituationInteractorInterface?
    
    // MARK: - Private properties

    private var bestDescriptionOfTheSituation: [BestDescriptionOfTheSituation] = []

    // MARK: - Initialization
    
    init(
        interactor: BestDescriptionOfTheSituationInteractorInterface,
        router: BestDescriptionOfTheSituationRouterInterface,
        view: BestDescriptionOfTheSituationViewControllerInterface
      ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - BestDescriptionOfTheSituationPresenterInterface

extension BestDescriptionOfTheSituationPresenter: BestDescriptionOfTheSituationPresenterInterface {
    func viewDidLoad() {
        bestDescriptionOfTheSituation = interactor?.getAllBestDescriptionOfTheSituation() ?? []
        
        view.set(bestDescriptionOfTheSituation: bestDescriptionOfTheSituation)
        
        if let currentOnboardingStage = interactor?.getCurrentOnboardingStage() {
            view.set(currentOnboardingStage: currentOnboardingStage)
        }
    }
    
    func didTapContinueCommonButton() {
        interactor?.set(bestDescriptionOfTheSituation: .livewithRoommates)
        router?.openEmotionalSupportSystem()
    }
}
