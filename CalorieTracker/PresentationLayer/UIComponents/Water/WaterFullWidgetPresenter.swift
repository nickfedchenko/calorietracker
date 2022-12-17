//
//  WaterFullWidgetPresenter.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 29.08.2022.
//

import UIKit

protocol WaterFullWidgetPresenterInterface: AnyObject {
    func getGoal() -> Int
    func getValueNow() -> Int
    func changeGoal(_ newGoal: Int)
    func saveQuickAddTypes(_ types: [QuickAddView.TypeQuickAdd])
    func getQuickAddTypes() -> [QuickAddView.TypeQuickAdd]
    func addWater(_ value: Int)
}

class WaterFullWidgetPresenter {
    unowned var view: WaterFullWidgetInterface
    
    private var quickAddTypes: [QuickAddView.TypeQuickAdd] = [
        .bottle(200),
        .jug(1000)
    ]
    
    init(view: WaterFullWidgetInterface) {
        self.view = view
    }
}

extension WaterFullWidgetPresenter: WaterFullWidgetPresenterInterface {
    func getGoal() -> Int {
        return Int(BAMeasurement(WaterWidgetService.shared.getDailyWaterGoal(), .liquid).localized)
    }
    
    func getValueNow() -> Int {
        Int(BAMeasurement(WaterWidgetService.shared.getWaterNow(), .liquid).localized)
    }
    
    func changeGoal(_ newGoal: Int) {
        let goal = BAMeasurement(Double(newGoal), .liquid).value
        WaterWidgetService.shared.setDailyWaterGoal(goal)
    }
    
    func addWater(_ value: Int) {
        let addValue = BAMeasurement(Double(value), .liquid).value
        WaterWidgetService.shared.addDailyWater(addValue)
    }
    
    func saveQuickAddTypes(_ types: [QuickAddView.TypeQuickAdd]) {
        quickAddTypes = types
    }
    
    func getQuickAddTypes() -> [QuickAddView.TypeQuickAdd] {
        return quickAddTypes
    }
}
