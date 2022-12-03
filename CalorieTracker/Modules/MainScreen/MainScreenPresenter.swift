//
//  MainScreenPresenter.swift
//  CIViperGenerator
//
//  Created by FedmanCassad on 18.07.2022.
//  Copyright © 2022 FedmanCassad. All rights reserved.
//

import UIKit

protocol MainScreenPresenterInterface: AnyObject {
    func didTapAddButton()
    func didTapWidget(_ type: WidgetContainerViewController.WidgetType)
    func updateWaterWidgetModel()
    func updateStepsWidget()
    func updateWeightWidget()
}

class MainScreenPresenter {

    unowned var view: MainScreenViewControllerInterface
    let router: MainScreenRouterInterface?
    let interactor: MainScreenInteractorInterface?

    init(
        interactor: MainScreenInteractorInterface,
        router: MainScreenRouterInterface,
        view: MainScreenViewControllerInterface
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension MainScreenPresenter: MainScreenPresenterInterface {
    func didTapAddButton() {
        router?.openAddFoodVC()
    }
    
    func didTapWidget(_ type: WidgetContainerViewController.WidgetType) {
        router?.openWidget(type)
    }
    
    func updateWaterWidgetModel() {
        let goal = WaterWidgetService.shared.getDailyWaterGoal()
        let waterNow = WaterWidgetService.shared.getWaterNow()
        
        let model = WaterWidgetNode.Model(
            progress: CGFloat(waterNow / goal),
            waterMl: "\(Int(waterNow)) / \(Int(goal)) ml"
        )
        
        view.setWaterWidgetModel(model)
    }
    
    func updateStepsWidget() {
        let goal = StepsWidgetService.shared.getDailyStepsGoal()
        let now = StepsWidgetService.shared.getStepsNow()
        
        view.setStepsWidget(now: Int(now), goal: goal)
    }
    
    func updateWeightWidget() {
        guard let weightNow = WeightWidgetService.shared.getWeightNow() else {
            view.setWeightWidget(weight: nil)
            return
        }
        view.setWeightWidget(weight: CGFloat(weightNow))
    }
}
