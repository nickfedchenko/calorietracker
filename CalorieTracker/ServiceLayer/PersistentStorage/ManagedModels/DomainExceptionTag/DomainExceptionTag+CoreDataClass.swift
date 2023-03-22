//
//  DomainExceptionTag+CoreDataClass.swift
//  
//
//  Created by Vladimir Banushkin on 21.03.2023.
//
//

import Foundation
import CoreData

@objc(DomainExceptionTag)
public class DomainExceptionTag: NSManagedObject {
    static func prepare(from plainModel: ExceptionTag, context: NSManagedObjectContext) -> DomainExceptionTag {
           let tag = DomainExceptionTag(context: context)
           tag.id = Int32(plainModel.id)
           tag.title = plainModel.title
           return tag
       }
}
