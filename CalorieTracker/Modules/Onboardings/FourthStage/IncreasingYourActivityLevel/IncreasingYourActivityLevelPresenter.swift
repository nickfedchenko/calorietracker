//
//  IncreasingYourActivityLevelPresenter.swift
//  CalorieTracker
//
//  Created by Алексей on 30.08.2022.
//

import Foundation

protocol IncreasingYourActivityLevelPresenterInterface: AnyObject {
    func viewDidLoad()
    func didTapApprovalCommonButton()
    func didTapRejectionCommonButton()
}

class IncreasingYourActivityLevelPresenter {
    
    // MARK: - Public properties
    
    unowned var view: IncreasingYourActivityLevelViewControllerInterface
    let router: IncreasingYourActivityLevelRouterInterface?
    let interactor: IncreasingYourActivityLevelInteractorInterface?

    // MARK: - Initialization
    
    init(
        interactor: IncreasingYourActivityLevelInteractorInterface,
        router: IncreasingYourActivityLevelRouterInterface,
        view: IncreasingYourActivityLevelViewControllerInterface
      ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - IncreasingYourActivityLevelPresenterInterface

extension IncreasingYourActivityLevelPresenter: IncreasingYourActivityLevelPresenterInterface {
    func viewDidLoad() {
        if let currentOnboardingStage = interactor?.getCurrentOnboardingStage() {
            view.set(currentOnboardingStage: currentOnboardingStage)
        }
    }
    
    func didTapApprovalCommonButton() {
        interactor?.set(increasingYourActivityLevel: true)
        router?.openHowImproveYourEfficiency()
    }
    
    func didTapRejectionCommonButton() {
        interactor?.set(increasingYourActivityLevel: false)
        router?.openHowImproveYourEfficiency()
    }
}
