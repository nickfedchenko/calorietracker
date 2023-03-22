//
//  DomainAdditionalTag+CoreDataClass.swift
//  
//
//  Created by Vladimir Banushkin on 20.03.2023.
//
//

import CoreData

@objc(DomainAdditionalTag)
public class DomainAdditionalTag: NSManagedObject {
    static func prepare(from plainModel: AdditionalTag, context: NSManagedObjectContext) -> DomainAdditionalTag {
        let tag = DomainAdditionalTag(context: context)
        tag.id = Int32(plainModel.id)
        tag.title = plainModel.title
        return tag
    }
}
