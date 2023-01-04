//
//  WidgetContainerPresenter.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 05.12.2022.
//

import Foundation

protocol WidgetContainerPresenterInterface: AnyObject {
    func didTapView()
    func openChangeWeightViewController(_ type: WeightKeyboardHeaderView.ActionType)
    func openChangeStepsViewController()
    func setGoalWater()
    func updateView()
}

final class WidgetContainerPresenter {

    unowned var view: WidgetContainerInterface
    let router: WidgetContainerRouterInterface?

    init(
        router: WidgetContainerRouterInterface,
        view: WidgetContainerInterface
      ) {
        self.view = view
        self.router = router
    }
}

extension WidgetContainerPresenter: WidgetContainerPresenterInterface {
    func didTapView() {
        router?.closeViewController()
    }
    
    func openChangeWeightViewController(_ type: WeightKeyboardHeaderView.ActionType) {
        router?.openChangeWeightViewController(type)
    }
    
    func openChangeStepsViewController() {
        router?.openChangeStepsViewController()
    }
    
    func updateView() {
        view.update()
    }
    
    func setGoalWater() {
        router?.openSetGoalWaterVC()
    }
}
