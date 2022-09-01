//
//  AllergicRestrictionsPresenter.swift
//  CalorieTracker
//
//  Created by Алексей on 28.08.2022.
//

import Foundation

protocol AllergicRestrictionsPresenterInterface: AnyObject {
    func viewDidLoad()
    func didTapContinueCommonButton()
}

class AllergicRestrictionsPresenter {
    
    // MARK: - Public properties

    unowned var view: AllergicRestrictionsViewControllerInterface
    let router: AllergicRestrictionsRouterInterface?
    let interactor: AllergicRestrictionsInteractorInterface?
    
    // MARK: - Private properties
    
    private var allergicRestrictions: [AllergicRestrictions] = []

    // MARK: - Initialization
    
    init(
        interactor: AllergicRestrictionsInteractorInterface,
        router: AllergicRestrictionsRouterInterface,
        view: AllergicRestrictionsViewControllerInterface
      ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - AllergicRestrictionsPresenterInterface

extension AllergicRestrictionsPresenter: AllergicRestrictionsPresenterInterface {
    func viewDidLoad() {
        allergicRestrictions = interactor?.getAllAllergicRestrictions() ?? []
        
        view.set(allergicRestrictions: allergicRestrictions)
        
        if let currentOnboardingStage = interactor?.getCurrentOnboardingStage() {
            view.set(currentOnboardingStage: currentOnboardingStage)
        }
    }
    
    func didTapContinueCommonButton() {
        interactor?.set(allergicRestrictions: .dairy)
        router?.openFinalOfTheSecondStage()
    }
}
