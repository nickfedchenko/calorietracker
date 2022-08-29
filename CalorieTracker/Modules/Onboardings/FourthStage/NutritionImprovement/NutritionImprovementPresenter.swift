//
//  NutritionImprovementPresenter.swift
//  CalorieTracker
//
//  Created by Алексей on 29.08.2022.
//

import Foundation

protocol NutritionImprovementPresenterInterface: AnyObject {
    func didTapApprovalCommonButton()
    func didTapRejectionCommonButton()
}

class NutritionImprovementPresenter {
    
    // MARK: - Public properties
    
    unowned var view: NutritionImprovementViewControllerInterface
    let router: NutritionImprovementRouterInterface?
    let interactor: NutritionImprovementInteractorInterface?

    // MARK: - Initialization
    
    init(
        interactor: NutritionImprovementInteractorInterface,
        router: NutritionImprovementRouterInterface,
        view: NutritionImprovementViewControllerInterface
      ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension NutritionImprovementPresenter: NutritionImprovementPresenterInterface {
    func didTapApprovalCommonButton() {
        interactor?.set(nutritionImprovement: true)
    }
    func didTapRejectionCommonButton() {
        interactor?.set(nutritionImprovement: false)
    }
}
