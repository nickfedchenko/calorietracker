//
//  WhatImportantToYouPresenter.swift
//  CalorieTracker
//
//  Created by Алексей on 30.08.2022.
//

import Foundation

protocol WhatImportantToYouPresenterInterface: AnyObject {
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
    func didTapCaloriesInMyFoodCommonButton() {
        interactor?.set(whatImportantToYou: true)
        router?.openThoughtsOnStressEating()
    }
    
    func didTapNutritionOfMyFoodCommonButton() {
        interactor?.set(whatImportantToYou: false)
        router?.openThoughtsOnStressEating()
    }
}
