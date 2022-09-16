//
//  HelpingPeopleTrackCaloriesPresenter.swift
//  CalorieTracker
//
//  Created by Алексей on 30.08.2022.
//

import Foundation

protocol HelpingPeopleTrackCaloriesPresenterInterface: AnyObject {
    func viewDidLoad()
    func didTapContinueCommonButton()
}

class HelpingPeopleTrackCaloriesPresenter {
    
    // MARK: - Public properties

    unowned var view: HelpingPeopleTrackCaloriesViewControllerInterface
    let router: HelpingPeopleTrackCaloriesRouterInterface?
    let interactor: HelpingPeopleTrackCaloriesInteractorInterface?

    // MARK: - Initialization
    
    init(
        interactor: HelpingPeopleTrackCaloriesInteractorInterface,
        router: HelpingPeopleTrackCaloriesRouterInterface,
        view: HelpingPeopleTrackCaloriesViewControllerInterface
      ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - HelpingPeopleTrackCaloriesPresenterInterface

extension HelpingPeopleTrackCaloriesPresenter: HelpingPeopleTrackCaloriesPresenterInterface {
    func viewDidLoad() {
        if let currentOnboardingStage = interactor?.getCurrentOnboardingStage() {
            view.set(currentOnboardingStage: currentOnboardingStage)
        }
    }
        
    func didTapContinueCommonButton() {
        router?.openStressAndEmotionsAreInevitable()
    }
}