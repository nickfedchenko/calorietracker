//
//  NutrientGoal.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 21.12.2022.
//

import UIKit

enum NutrientGoalType: Codable {
    case `default`
    case lowCarb
    case highProtein
    case lowFat
    case custom(NutrientPercent)
}

struct NutrientPercent: Codable {
    let fat: Double
    let protein: Double
    let carbs: Double
}

extension NutrientGoalType: WithGetTitleProtocol {
    func getTitle(_ lenght: Lenght) -> String? {
        switch self {
        case .default:
            return R.string.localizable.default()
        case .lowCarb:
            return R.string.localizable.lowCarb()
        case .highProtein:
            return R.string.localizable.highProtein()
        case .lowFat:
            return R.string.localizable.lowFat()
        case .custom:
            return R.string.localizable.custom()
        }
    }
}

extension NutrientGoalType: WithGetImageProtocol {
    func getImage() -> UIImage? {
        return nil
    }
}

extension NutrientGoalType: WithGetDescriptionProtocol {
    func getDescription() -> NSAttributedString? {
        let nutrientPercent = self.getNutrientPercent()
        let carbsPer = Int(nutrientPercent.carbs * 100)
        let proteinsPer = Int(nutrientPercent.protein * 100)
        let fatPer = Int(nutrientPercent.fat * 100)
        
        let str = "carbs \(carbsPer)%, protein \(proteinsPer)%, fat \(fatPer)%"
        
        let font = R.font.sfProTextMedium(size: 14.fontScale())
        
        return str.attributedSring([
            .init(
                worldIndex: [1, 3, 5],
                attributes: [
                    .font(font),
                    .color(R.color.foodViewing.basicPrimary())
                ]
            ),
            .init(
                worldIndex: [0],
                attributes: [
                    .font(font),
                    .color(R.color.foodViewing.carbSecond())
                ]
            ),
            .init(
                worldIndex: [2],
                attributes: [
                    .font(font),
                    .color(R.color.foodViewing.proteinSecond())
                ]
            ),
            .init(
                worldIndex: [4],
                attributes: [
                    .font(font),
                    .color(R.color.foodViewing.fatSecond())
                ]
            )
        ])
    }
}

extension NutrientGoalType {
    func getNutrientPercent() -> NutrientPercent {
        switch self {
        case .default:
            return NutrientPercent(fat: 0.3, protein: 0.2, carbs: 0.5)
        case .lowCarb:
            return NutrientPercent(fat: 0.45, protein: 0.25, carbs: 0.3)
        case .highProtein:
            return NutrientPercent(fat: 0.25, protein: 0.4, carbs: 0.35)
        case .lowFat:
            return NutrientPercent(fat: 0.25, protein: 0.2, carbs: 0.55)
        case .custom(let data):
            return data
        }
    }
}
