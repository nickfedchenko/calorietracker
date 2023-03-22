//
//  DomainDishTypeTag+CoreDataClass.swift
//  
//
//  Created by Vladimir Banushkin on 20.03.2023.
//
//

import CoreData

@objc(DomainDishTypeTag)
public class DomainDishTypeTag: NSManagedObject {
    static func prepare(from plainModel: AdditionalTag, context: NSManagedObjectContext) -> DomainDishTypeTag {
        let tag = DomainDishTypeTag(context: context)
        tag.id = Int32(plainModel.id)
        tag.title = plainModel.title
        return tag
    }
}
