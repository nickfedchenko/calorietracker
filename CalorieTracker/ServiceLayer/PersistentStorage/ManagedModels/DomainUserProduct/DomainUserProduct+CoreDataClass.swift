//
//  DomainUserProduct+CoreDataClass.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 23.11.2022.
//

import CoreData

@objc(DomainUserProduct)
public class DomainUserProduct: NSManagedObject {
    static func prepare(fromPlainModel model: UserProduct, context: NSManagedObjectContext) -> DomainUserProduct {
        let product = DomainUserProduct(context: context)
        product.id = model.id

        return product
    }
}
