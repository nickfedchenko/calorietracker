//
//  WhatIsYourGoalWeightPresenter.swift
//  CalorieTracker
//
//  Created by Алексей on 29.08.2022.
//

import Foundation

protocol WhatIsYourGoalWeightPresenterInterface: AnyObject {
    func viewDidLoad()
    func didTapContinueCommonButton()
}

class WhatIsYourGoalWeightPresenter {
    
    // MARK: - Public properties

    unowned var view: WhatIsYourGoalWeightViewControllerInterface
    let router: WhatIsYourGoalWeightRouterInterface?
    let interactor: WhatIsYourGoalWeightInteractorInterface?

    // MARK: - Initialization
    
    init(
        interactor: WhatIsYourGoalWeightInteractorInterface,
        router: WhatIsYourGoalWeightRouterInterface,
        view: WhatIsYourGoalWeightViewControllerInterface
      ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - WhatIsYourGoalWeightPresenterInterface

extension WhatIsYourGoalWeightPresenter: WhatIsYourGoalWeightPresenterInterface {
    func viewDidLoad() {
        if let currentOnboardingStage = interactor?.getCurrentOnboardingStage() {
            view.set(currentOnboardingStage: currentOnboardingStage)
        }
    }
    
    func didTapContinueCommonButton() {
        interactor?.set(whatIsYourGoalWeight: "dasda")
        router?.openFinalOfTheThirdStage()
    }
}
