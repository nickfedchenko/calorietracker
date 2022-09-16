//
//  ThoughtsOnStressEatingPresenter.swift
//  CalorieTracker
//
//  Created by Алексей on 30.08.2022.
//

import Foundation

protocol ThoughtsOnStressEatingPresenterInterface: AnyObject {
    func viewDidLoad()
    func didTapApprovalCommonButton()
    func didTapRejectionCommonButton()
}

class ThoughtsOnStressEatingPresenter {
    
    // MARK: - Public properties
    
    unowned var view: ThoughtsOnStressEatingViewControllerInterface
    let router: ThoughtsOnStressEatingRouterInterface?
    let interactor: ThoughtsOnStressEatingInteractorInterface?

    // MARK: - Initialization
    
    init(
        interactor: ThoughtsOnStressEatingInteractorInterface,
        router: ThoughtsOnStressEatingRouterInterface,
        view: ThoughtsOnStressEatingViewControllerInterface
      ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - ThoughtsOnStressEatingPresenterInterface

extension ThoughtsOnStressEatingPresenter: ThoughtsOnStressEatingPresenterInterface {    
    func viewDidLoad() {
        if let currentOnboardingStage = interactor?.getCurrentOnboardingStage() {
            view.set(currentOnboardingStage: currentOnboardingStage)
        }
    }
    
    func didTapApprovalCommonButton() {
        interactor?.set(thoughtsOnStressEating: true)
        router?.openHelpingPeopleTrackCalories()
    }
    
    func didTapRejectionCommonButton() {
        interactor?.set(thoughtsOnStressEating: false)
        router?.openHelpingPeopleTrackCalories()
    }
}
