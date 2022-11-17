//
//  FoodViewingPresenter.swift
//  CIViperGenerator
//
//  Created by Mov4D on 15.11.2022.
//  Copyright © 2022 Mov4D. All rights reserved.
//

import Foundation

protocol FoodViewingPresenterInterface: AnyObject {
    func getDailyFoodIntake() -> DailyFoodIntake
    func didTapCloseButton()
}

class FoodViewingPresenter {
    
    unowned var view: FoodViewingViewControllerInterface
    let router: FoodViewingRouterInterface?
    let interactor: FoodViewingInteractorInterface?
    
    init(
        interactor: FoodViewingInteractorInterface,
        router: FoodViewingRouterInterface,
        view: FoodViewingViewControllerInterface
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension FoodViewingPresenter: FoodViewingPresenterInterface {
    func getDailyFoodIntake() -> DailyFoodIntake {
        return .init(fat: 100, protein: 100, kcal: 100, carb: 100)
    }
    
    func didTapCloseButton() {
        router?.closeViewController()
    }
}
