//
//  PurposeOfTheParishPresenter.swift
//  CalorieTracker
//
//  Created by Алексей on 21.08.2022.
//

import Foundation

protocol PurposeOfTheParishPresenterInterface: AnyObject {
    func viewDidLoad()
    func didTapNextCommonButton()
    func didSelectPurposeOfTheParish(with index: Int)
    func didDeselectPurposeOfTheParish()
}

class PurposeOfTheParishPresenter {
    
    // MARK: - Public properties
    
    unowned var view: PurposeOfTheParishViewControllerInterface
    let router: PurposeOfTheParishRouterInterface?
    let interactor: PurposeOfTheParishInteractorInterface?
    
    // MARK: - Private properties
    
    private var purposeOfTheParish: [PurposeOfTheParish] = []
    private var purposeOfTheParishIndex: Int?

    // MARK: - Initialization
    
    init(
        interactor: PurposeOfTheParishInteractorInterface,
        router: PurposeOfTheParishRouterInterface,
        view: PurposeOfTheParishViewControllerInterface
      ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - PurposeOfTheParishPresenterInterface

extension PurposeOfTheParishPresenter: PurposeOfTheParishPresenterInterface {
    func viewDidLoad() {
        purposeOfTheParish = interactor?.getAllPurposeOfTheParish() ?? []
        
        view.set(purposeOfTheParish: purposeOfTheParish)
        
        if let currentOnboardingStage = interactor?.getCurrentOnboardingStage() {
            view.set(currentOnboardingStage: currentOnboardingStage)
        }
    }
    
    func didTapNextCommonButton() {
        interactor?.set(purposeOfTheParish: .thisTimeToGetBackToHealthyHabits)
        router?.openCallToAchieveGoal()
    }
    
    func didSelectPurposeOfTheParish(with index: Int) {
        purposeOfTheParishIndex = index
    }
    
    func didDeselectPurposeOfTheParish() {
        purposeOfTheParishIndex = nil
    }
}
