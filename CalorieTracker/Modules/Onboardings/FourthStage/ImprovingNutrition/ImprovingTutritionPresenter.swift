//
//  ImprovingTutritionPresenter.swift
//  CalorieTracker
//
//  Created by Алексей on 30.08.2022.
//

import Foundation

protocol ImprovingNutritionPresenterInterface: AnyObject {
    func viewDidLoad()
    func didTapContinueCommonButton()
}

class ImprovingNutritionPresenter {
    
    // MARK: - Public properties

    unowned var view: ImprovingNutritionViewControllerInterface
    let router: ImprovingNutritionRouterInterface?
    let interactor: ImprovingNutritionInteractorInterface?
    
    // MARK: - Private properties

    private var improvingNutrition: [ImprovingNutrition] = []

    // MARK: - Initialization
    
    init(
        interactor: ImprovingNutritionInteractorInterface,
        router: ImprovingNutritionRouterInterface,
        view: ImprovingNutritionViewControllerInterface
      ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - ImprovingNutritionPresenterInterface

extension ImprovingNutritionPresenter: ImprovingNutritionPresenterInterface {
    func viewDidLoad() {
        improvingNutrition = interactor?.getAllImprovingNutrition() ?? []
        
        view.set(improvingNutrition: improvingNutrition)
    }
    
    func didTapContinueCommonButton() {
        interactor?.set(improvingNutrition: .aimingForMoreFruitVeggies)
        router?.openSoundsLikePlan()
    }
}
