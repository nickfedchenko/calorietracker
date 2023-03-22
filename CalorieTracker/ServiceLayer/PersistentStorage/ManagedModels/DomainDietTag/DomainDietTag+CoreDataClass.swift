//
//  DomainDietTag+CoreDataClass.swift
//  
//
//  Created by Vladimir Banushkin on 20.03.2023.
//
//

import CoreData

@objc(DomainDietTag)
public class DomainDietTag: NSManagedObject {
    static func prepare(from plainModel: AdditionalTag, context: NSManagedObjectContext) -> DomainDietTag {
        let tag = DomainDietTag(context: context)
        tag.id = Int32(plainModel.id)
        tag.title = plainModel.title
        return tag
    }
}
