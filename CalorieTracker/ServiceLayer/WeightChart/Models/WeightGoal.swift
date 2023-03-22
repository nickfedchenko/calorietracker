//
//  WeightGoal.swift
//  CalorieTracker
//
//  Created by Алексей on 06.09.2022.
//

enum WeightGoal {
    case gain(calorieSurplus: Double)
    case loss(calorieDeficit: Double)
    case maintain(calorieDeficit: Double)
}
