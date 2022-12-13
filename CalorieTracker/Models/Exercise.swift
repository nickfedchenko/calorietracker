//
//  Exercise.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 06.12.2022.
//

import Foundation

struct Exercise {
    let date: Date
    let type: ExerciseType
    let burnedKcal: Double
    
    init(date: Date, type: ExerciseType, burnedKcal: Double) {
        self.burnedKcal = burnedKcal
        self.date = date
        self.type = type
    }
    
    init?(from managedModel: DomainExercise) {
        self.date = managedModel.date
        self.burnedKcal = managedModel.burnedKcal
        self.type = {
            guard let type = try? JSONDecoder()
                .decode(ExerciseType.self, from: managedModel.exerciseType)
            else { return .default }
            return type
        }()
    }
}
