//
//  DomainExercise+CoreDataClass.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 06.12.2022.
//

import CoreData

@objc(DomainExercise)
public class DomainExercise: NSManagedObject {
    static func prepare(fromPlainModel model: Exercise, context: NSManagedObjectContext) -> DomainExercise {
        let exercise = DomainExercise(context: context)
        exercise.date = model.date
        exercise.burnedKcal = model.burnedKcal
        exercise.exerciseType = (try? JSONEncoder().encode(model.type)) ?? Data()
        return exercise
    }
}
