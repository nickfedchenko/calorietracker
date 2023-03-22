//
//  DomainProcessingTag+CoreDataClass.swift
//  
//
//  Created by Vladimir Banushkin on 20.03.2023.
//
//

import CoreData

@objc(DomainProcessingTag)
public class DomainProcessingTag: NSManagedObject {
    static func prepare(from plainModel: AdditionalTag, context: NSManagedObjectContext) -> DomainProcessingTag {
        let tag = DomainProcessingTag(context: context)
        tag.id = Int32(plainModel.id)
        tag.title = plainModel.title
        return tag
    }
}
