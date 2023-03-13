//
//  PresenceOfAllergiesPresenter.swift
//  CalorieTracker
//
//  Created by Алексей on 28.08.2022.
//

import Foundation

protocol PresenceOfAllergiesPresenterInterface: AnyObject {
    func viewDidLoad()
    func didTapContinueCommonButton()
    func didSelectPresenceOfAllergies(with index: Int)
    func didDeselectPresenceOfAllergies()
}

class PresenceOfAllergiesPresenter {
    
    // MARK: - Public properties

    unowned var view: PresenceOfAllergiesViewControllerInterface
    let router: PresenceOfAllergiesRouterInterface?
    let interactor: PresenceOfAllergiesInteractorInterface?
    
    // MARK: - Private properties

    private var presenceOfAllergies: [PresenceOfAllergies] = []
    private var presenceOfAllergiesIndex: Int?

    // MARK: - Initialization
    
    init(
        interactor: PresenceOfAllergiesInteractorInterface,
        router: PresenceOfAllergiesRouterInterface,
        view: PresenceOfAllergiesViewControllerInterface
      ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - PresenceOfAllergiesPresenterInterface

extension PresenceOfAllergiesPresenter: PresenceOfAllergiesPresenterInterface {
    func viewDidLoad() {
        presenceOfAllergies = interactor?.getAllPresenceOfAllergies() ?? []
        
        view.set(presenceOfAllergies: presenceOfAllergies)
        
        if let currentOnboardingStage = interactor?.getCurrentOnboardingStage() {
            view.set(currentOnboardingStage: currentOnboardingStage)
        }
    }
    
    func didTapContinueCommonButton() {
        switch presenceOfAllergiesIndex {
        case 0:
            interactor?.set(presenceOfAllergies: .yes)
            router?.openAllergicRestrictions()
        default:
            interactor?.set(presenceOfAllergies: .no)
            router?.openThanksForTheInformation()
        }
    }
    
    func didSelectPresenceOfAllergies(with index: Int) {
        presenceOfAllergiesIndex = index
    }
    
    func didDeselectPresenceOfAllergies() {
        presenceOfAllergiesIndex = nil
    }
}
