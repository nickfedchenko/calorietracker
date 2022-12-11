//
//  ExerciseWidgetServise.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 06.12.2022.
//

import Foundation

protocol ExerciseWidgetServiseInterface {
    func getAllExerciseData() -> [Exercise]
    func getBurnedKclaGoal() -> Double?
    func addExercise(type: ExerciseType, burnedKcal: Double)
    func setBurnedKcalGoal(_ value: Double)
    func getExercisesToday() -> [Exercise]
    func getBurnedKcalToday() -> Double
}

final class ExerciseWidgetServise {
    static let shared: ExerciseWidgetServiseInterface = ExerciseWidgetServise()
    
    private let localDomainService: LocalDomainServiceInterface = LocalDomainService()
}

extension ExerciseWidgetServise: ExerciseWidgetServiseInterface {
    func getAllExerciseData() -> [Exercise] {
        localDomainService.fetchExercise()
    }
    
    func getExercisesToday() -> [Exercise] {
        let today = Date().day
        return localDomainService.fetchExercise().filter {
            $0.date.day == today
        }
    }
    
    func getBurnedKclaGoal() -> Double? {
        UDM.burnedKcalGoal
    }
    
    func getBurnedKcalToday() -> Double {
        getExercisesToday().map { $0.burnedKcal }.sum()
    }
    
    func setBurnedKcalGoal(_ value: Double) {
        UDM.burnedKcalGoal = value
    }
    
    func addExercise(type: ExerciseType, burnedKcal: Double) {
        let exercise: Exercise = .init(date: Date(), type: type, burnedKcal: burnedKcal)
        localDomainService.saveExercise(data: [exercise])
    }
}