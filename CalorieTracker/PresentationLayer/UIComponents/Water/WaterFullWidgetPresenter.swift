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
    
    private var valueNow = 1600
    private var goal = 2000
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
        return Int(WaterWidgetService.shared.getDailyWaterGoal())
    }
    
    func getValueNow() -> Int {
        Int(WaterWidgetService.shared.getWaterNow())
    }
    
    func changeGoal(_ newGoal: Int) {
        WaterWidgetService.shared.setDailyWaterGoal(Double(newGoal))
    }
    
    func addWater(_ value: Int) {
        WaterWidgetService.shared.addDailyWater(Double(value))
    }
    
    func saveQuickAddTypes(_ types: [QuickAddView.TypeQuickAdd]) {
        quickAddTypes = types
    }
    
    func getQuickAddTypes() -> [QuickAddView.TypeQuickAdd] {
        return quickAddTypes
    }
}
