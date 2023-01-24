//
//  DomainNote+CoreDataClass.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 08.01.2023.
//

import CoreData

@objc(DomainNote)
public class DomainNote: NSManagedObject {
    static func prepare(fromPlainModel model: Note, context: NSManagedObjectContext) -> DomainNote {
        let note = DomainNote(context: context)
        note.id = model.id
        note.text = model.text
        note.imageUrl = model.imageUrl
        note.estimation = Int16(model.estimation.rawValue)
        note.date = model.date
        
        return note
    }
}
