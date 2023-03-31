//
//  HKWorkoutActivityType+ExerciseType.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 14.12.2022.
//

import HealthKit

// swiftlint:disable: switch_case_on_newline
extension HKWorkoutActivityType {
    var name: ExerciseType {
        switch self {
        case .badminton: return .badminton
        case .baseball: return .baseball
        case .basketball: return .basketball
        case .boxing: return .boxing
        case .mixedCardio: return .cardio
        case .cooldown: return .cooldown
        case .coreTraining: return .core
        case .cardioDance, .socialDance: return .dance
        case .elliptical: return .elliptical
        case .hockey: return .hockey
        case .handCycling: return .indoorCycling
        case .jumpRope: return .jumprope
        case .kickboxing: return .kickboxing
        case .cycling: return .outdoorCycling
        case .pilates: return .pilates
        case .running: return .run
        case .skatingSports: return .skating
        case .snowboarding: return .snowboarding
        case .stairs: return .stairs
        case .stepTraining: return .stepTraining
        case .functionalStrengthTraining, .traditionalStrengthTraining: return .strengthTraining
        case .swimming: return .swim
        case .walking: return .walk
        case .waterFitness: return .waterFitness
        case .waterPolo: return .waterPolo
        case .yoga: return .yoga
        case .tableTennis: return .tableTennis
        default: return .run
        }
    }
}
