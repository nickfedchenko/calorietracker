//
//  CalorieTrackingViaKcalcPresenter.swift
//  CalorieTracker
//
//  Created by Алексей on 31.08.2022.
//

import Foundation

protocol CalorieTrackingViaKcalcPresenterInterface: AnyObject {
    func didTapContinueWithoutRegistrationButton()
}

class CalorieTrackingViaKcalcPresenter {
    
    // MARK: - Public properties

    unowned var view: CalorieTrackingViaKcalcViewControllerInterface
    let router: CalorieTrackingViaKcalcRouterInterface?
    let interactor: CalorieTrackingViaKcalcInteractorInterface?

    // MARK: - Initialization
        
    init(
        interactor: CalorieTrackingViaKcalcInteractorInterface,
        router: CalorieTrackingViaKcalcRouterInterface,
        view: CalorieTrackingViaKcalcViewControllerInterface
        ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - CalorieTrackingViaKcalcPresenterInterface

extension CalorieTrackingViaKcalcPresenter: CalorieTrackingViaKcalcPresenterInterface {
    func didTapContinueWithoutRegistrationButton() {
        _ = OnboardingSaveDataService(OnboardingManager.shared.getOnboardingInfo())
        router?.openMainController()
    }
}
