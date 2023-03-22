//
//  DomainEatingTag+CoreDataClass.swift
//  
//
//  Created by Vladimir Banushkin on 20.03.2023.
//
//

import CoreData

@objc(DomainEatingTag)
public class DomainEatingTag: NSManagedObject {
    static func prepare(from plainModel: AdditionalTag, context: NSManagedObjectContext) -> DomainEatingTag {
        let tag = DomainEatingTag(context: context)
        tag.id = Int32(plainModel.id)
        tag.title = plainModel.title
        return tag
    }
}
