//
//  DomainExercise+CoreDataProperties.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 06.12.2022.
//

import CoreData

extension DomainExercise {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DomainExercise> {
        return NSFetchRequest<DomainExercise>(entityName: "DomainExercise")
    }

    @NSManaged public var date: Date
    @NSManaged public var exerciseType: Data
    @NSManaged public var burnedKcal: Double
}
