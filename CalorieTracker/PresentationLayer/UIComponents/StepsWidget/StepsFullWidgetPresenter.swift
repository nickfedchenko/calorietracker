//
//  StepsFullWidgetPresenter.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 05.12.2022.
//

import UIKit

protocol StepsFullWidgetPresenterInterface: AnyObject {
    func updateModel()
}

class StepsFullWidgetPresenter {
    unowned var view: StepsFullWidgetInterface
    
    init(view: StepsFullWidgetInterface) {
        self.view = view
    }
}

extension StepsFullWidgetPresenter: StepsFullWidgetPresenterInterface {
    func updateModel() {
        let model = StepsFullWidgetView.Model(
            nowSteps: Int(StepsWidgetService.shared.getStepsNow()),
            goalSteps: StepsWidgetService.shared.getDailyStepsGoal()
        )
        
        view.setModel(model)
    }
}
