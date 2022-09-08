//
//  TimeToSeeYourGoalWeightPresenter.swift
//  CalorieTracker
//
//  Created by Алексей on 29.08.2022.
//

import Foundation

protocol TimeToSeeYourGoalWeightPresenterInterface: AnyObject {
    func viewDidLoad()
    func didTapSetGoalWeightCommonButton()
}

class TimeToSeeYourGoalWeightPresenter {
    
    // MARK: - Public properties

    unowned var view: TimeToSeeYourGoalWeightViewControllerInterface
    let router: TimeToSeeYourGoalWeightRouterInterface?
    let interactor: TimeToSeeYourGoalWeightInteractorInterface?

    // MARK: - Initialization
    
    init(
        interactor: TimeToSeeYourGoalWeightInteractorInterface,
        router: TimeToSeeYourGoalWeightRouterInterface,
        view: TimeToSeeYourGoalWeightViewControllerInterface
      ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - TimeToSeeYourGoalWeightPresenterInterface

extension TimeToSeeYourGoalWeightPresenter: TimeToSeeYourGoalWeightPresenterInterface {
    func viewDidLoad() {
        if let currentOnboardingStage = interactor?.getCurrentOnboardingStage() {
            view.set(currentOnboardingStage: currentOnboardingStage)
        }
    }
    
    func didTapSetGoalWeightCommonButton() {
        router?.openWhatIsYourGoalWeight()
    }
}
