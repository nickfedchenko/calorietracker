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
    func getQuickAddTypes() -> [QuickAddModel]
    func addWater(_ value: Int)
    func getSliderStepVolume() -> Int
    func getCountSliderParts() -> Int
    func addQuickAddTypes(_ type: QuickAddModel)
}

class WaterFullWidgetPresenter {
    unowned var view: WaterFullWidgetInterface
    
    private let countSliderParts = 15
    private let stepMl: Double = 50
    
    private var quickAddTypes: [QuickAddModel] = [
        .init(type: .bottle, value: 100),
        .init(type: .cup, value: 50)
    ]
    
    init(view: WaterFullWidgetInterface) {
        self.view = view
        if let models = UDM.quickAddWaterModels {
            quickAddTypes = models
        }
    }
}

extension WaterFullWidgetPresenter: WaterFullWidgetPresenterInterface {
    func getGoal() -> Int {
        let value = WaterWidgetService.shared.getDailyWaterGoal()
        return Int(BAMeasurement(value, .liquid, isMetric: true).localized)
    }
    
    func getValueNow() -> Int {
        let value = WaterWidgetService.shared.getWaterNow()
        return Int(BAMeasurement(value, .liquid, isMetric: true).localized)
    }
    
    func addWater(_ value: Int) {
        let addValue = BAMeasurement(Double(value), .liquid).value
        WaterWidgetService.shared.addDailyWater(addValue)
    }
    
    func getQuickAddTypes() -> [QuickAddModel] {
        return quickAddTypes
    }
    
    func getSliderStepVolume() -> Int {
        Int(BAMeasurement(stepMl, .liquid, isMetric: true).localized)
    }
    
    func getCountSliderParts() -> Int {
        self.countSliderParts
    }
    
    func addQuickAddTypes(_ type: QuickAddModel) {
        var newArray = quickAddTypes
        newArray.append(type)
        self.quickAddTypes = newArray
        UDM.quickAddWaterModels = quickAddTypes
    }
}
