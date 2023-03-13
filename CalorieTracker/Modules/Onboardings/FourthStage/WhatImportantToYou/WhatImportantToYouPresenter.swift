//
//  WhatImportantToYouPresenter.swift
//  CalorieTracker
//
//  Created by Алексей on 30.08.2022.
//

import Foundation

protocol WhatImportantToYouPresenterInterface: AnyObject {
    func viewDidLoad()
    func didTapCaloriesInMyFoodCommonButton()
    func didTapNutritionOfMyFoodCommonButton()
}

class WhatImportantToYouPresenter {
    
    // MARK: - Public properties
    
    unowned var view: WhatImportantToYouViewControllerInterface
    let router: WhatImportantToYouRouterInterface?
    let interactor: WhatImportantToYouInteractorInterface?

    // MARK: - Initialization
    
    init(
        interactor: WhatImportantToYouInteractorInterface,
        router: WhatImportantToYouRouterInterface,
        view: WhatImportantToYouViewControllerInterface
      ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - WhatImportantToYouPresenterInterface

extension WhatImportantToYouPresenter: WhatImportantToYouPresenterInterface {
    func viewDidLoad() {
        if let currentOnboardingStage = interactor?.getCurrentOnboardingStage() {
            view.set(currentOnboardingStage: currentOnboardingStage)
        }
    }
    
    func didTapCaloriesInMyFoodCommonButton() {
        interactor?.set(whatImportantToYou: true)
        router?.openBestDescriptionOfTheSituation()
    }
    
    func didTapNutritionOfMyFoodCommonButton() {
        interactor?.set(whatImportantToYou: false)
        router?.openBestDescriptionOfTheSituation()
    }
}
