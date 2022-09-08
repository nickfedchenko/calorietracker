//
//  WeightChartService.swift
//  CalorieTracker
//
//  Created by Алексей on 06.09.2022.
//

protocol WeightChartService {
    func calculateWeightGoal(currentWeight: Double, targetWeight: Double, rate: Double) -> WeightGoal
}

// MARK: - WeightChartService

class WeightChartServiceImp: WeightChartService {
    func calculateWeightGoal(currentWeight: Double, targetWeight: Double, rate: Double) -> WeightGoal {
        if currentWeight < targetWeight {
            return .gain(calorieSurplus: 15.0)
        } else {
            return .loss(calorieDeficit: 0.8)
        }
    }
}
