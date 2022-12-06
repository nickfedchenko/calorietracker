//
//  ExerciseType.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 29.07.2022.
//

import UIKit

enum ExerciseType: Codable {
    case badminton
    case baseball
    case basketball
    case boxing
    case cardio
    case cooldown
    case core
    case dance
    case dumbbell
    case elliptical
    case hockey
    case indoorCycling
    case jumprope
    case kickboxing
    case outdoorCycling
    case pilates
    case run
    case skating
    case skiing
    case snowboarding
    case stairs
    case stepTraining
    case strengthTraining
    case swim
    case walk
    case waterFitness
    case waterPolo
    case yoga
    case `default`
}

extension ExerciseType {
    var image: UIImage? {
        switch self {
        case .badminton:
            return R.image.exercisesWidget.fitness.badminton()
        case .baseball:
            return R.image.exercisesWidget.fitness.baseball()
        case .basketball:
            return R.image.exercisesWidget.fitness.basketball()
        case .boxing:
            return R.image.exercisesWidget.fitness.boxing()
        case .cardio:
            return R.image.exercisesWidget.fitness.cardio()
        case .cooldown:
            return R.image.exercisesWidget.fitness.cooldown()
        case .core:
            return R.image.exercisesWidget.fitness.core()
        case .dance:
            return R.image.exercisesWidget.fitness.dance()
        case .dumbbell:
            return R.image.exercisesWidget.fitness.dumbbell()
        case .elliptical:
            return R.image.exercisesWidget.fitness.elliptical()
        case .hockey:
            return R.image.exercisesWidget.fitness.hockey()
        case .indoorCycling:
            return R.image.exercisesWidget.fitness.indoorCycling()
        case .jumprope:
            return R.image.exercisesWidget.fitness.jumprope()
        case .kickboxing:
            return R.image.exercisesWidget.fitness.kickboxing()
        case .outdoorCycling:
            return R.image.exercisesWidget.fitness.outdoorCycling()
        case .pilates:
            return R.image.exercisesWidget.fitness.pilates()
        case .run:
            return R.image.exercisesWidget.fitness.run()
        case .skating:
            return R.image.exercisesWidget.fitness.skating()
        case .skiing:
            return R.image.exercisesWidget.fitness.skiing()
        case .snowboarding:
            return R.image.exercisesWidget.fitness.snowboarding()
        case .stairs:
            return R.image.exercisesWidget.fitness.stairs()
        case .stepTraining:
            return R.image.exercisesWidget.fitness.stepTraining()
        case .strengthTraining:
            return R.image.exercisesWidget.fitness.strengthTraining()
        case .swim:
            return R.image.exercisesWidget.fitness.swim()
        case .walk:
            return R.image.exercisesWidget.fitness.walk()
        case .waterFitness:
            return R.image.exercisesWidget.fitness.waterFitness()
        case .waterPolo:
            return R.image.exercisesWidget.fitness.waterPolo()
        case .yoga:
            return R.image.exercisesWidget.fitness.yoga()
        default:
            return nil
        }
    }
}
