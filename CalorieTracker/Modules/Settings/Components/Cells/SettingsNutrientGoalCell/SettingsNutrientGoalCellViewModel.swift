//
//  SettingsNutrientGoalCellViewModel.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 21.12.2022.
//

import UIKit

protocol SettingsNutrientGoalCellViewModelOutput: AnyObject {
    func updateView(percentTitle: String,
                    nutrientTypeTitle: String,
                    kcalTitle: String,
                    weightTitle: String,
                    percentForSlider: Float)
}

struct SettingsNutrientGoalCellViewModel {
    weak var output: SettingsNutrientGoalCellViewModelOutput? {
        didSet {
            updateView()
        }
    }
    
    let nutrientType: NutrientType
    private let kcalPerPercentage: Double
    
    private var percent: Int {
        didSet {
            if percent != oldValue {
                updateView()
            }
        }
    }
    
    init(percent: Int, kcalPerPercentage: Double, nutrientType: NutrientType) {
        self.percent = percent
        self.kcalPerPercentage = kcalPerPercentage
        self.nutrientType = nutrientType
    }
    
    mutating func setPercent(_ value: Int) {
        self.percent = value
    }
    
    func getSliderColor() -> UIColor? {
        switch nutrientType {
        case .fat:
            return R.color.foodViewing.fatFirst()
        case .protein:
            return R.color.foodViewing.proteinFirst()
        case .carbs:
            return R.color.foodViewing.carbFirst()
        }
    }
    
    func getTitleColor() -> UIColor? {
        switch nutrientType {
        case .fat:
            return R.color.foodViewing.fatSecond()
        case .protein:
            return R.color.foodViewing.proteinSecond()
        case .carbs:
            return R.color.foodViewing.carbSecond()
        }
    }
    
    private func updateView() {
        let percentForSlider = Float(percent) / 100.0
        let percentTitle = "\(percent)%"
        let nutrientTypeTitle = nutrientType.getTitle(.long) ?? ""
        let kcal = Double(percent) * kcalPerPercentage
        let kcalTitle = "(\(BAMeasurement(kcal, .energy, isMetric: true).string))"
        let weight = NutrientMeasurment.convert(
            value: kcal,
            type: nutrientType,
            from: .kcal,
            to: .gram
        )
        let weightTitle = BAMeasurement(weight, .serving, isMetric: true).string
        
        output?.updateView(
            percentTitle: percentTitle,
            nutrientTypeTitle: nutrientTypeTitle,
            kcalTitle: kcalTitle,
            weightTitle: weightTitle,
            percentForSlider: percentForSlider
        )
    }
}

extension NutrientType: WithGetTitleProtocol {
    func getTitle(_ lenght: Lenght) -> String? {
        switch self {
        case .fat:
            return R.string.localizable.fatShort().capitalized
        case .protein:
            return R.string.localizable.protein().capitalized
        case .carbs:
            return R.string.localizable.carbsShort().capitalized
        }
    }
}
