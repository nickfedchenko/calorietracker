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
    func getPercentage() -> Double
}

class WaterFullWidgetPresenter {
    unowned var view: WaterFullWidgetInterface
    
    private var specificDate: Date
    private let countSliderParts = 15
    private let stepMl: Double = 50
    
    private var quickAddTypes: [QuickAddModel] = [
        .init(type: .bottle, value: 500),
        .init(type: .cup, value: 200)
    ]
    
    init(view: WaterFullWidgetInterface, specificDate: Date = Date()) {
        self.view = view
        self.specificDate = specificDate
        if let models = UDM.quickAddWaterModels {
            quickAddTypes = models
        }
    }
}

extension WaterFullWidgetPresenter: WaterFullWidgetPresenterInterface {
    
    func getPercentage() -> Double {
        let goal = getGoal()
        let now = getValueNow()
        return Double(now) / Double(goal)
    }
    
    func getGoal() -> Int {
        let value = WaterWidgetService.shared.getDailyWaterGoal()
        return Int(BAMeasurement(value, .liquid, isMetric: true).localized)
    }
    
    func getValueNow() -> Int {
        let value = WaterWidgetService.shared.getWaterForDate(specificDate)
        return Int(BAMeasurement(value, .liquid, isMetric: true).localized)
    }
    
    func addWater(_ value: Int) {
        let addValue = BAMeasurement(Double(value), .liquid).value
        WaterWidgetService.shared.addWaterToSpecificDate(addValue, date: specificDate)
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
