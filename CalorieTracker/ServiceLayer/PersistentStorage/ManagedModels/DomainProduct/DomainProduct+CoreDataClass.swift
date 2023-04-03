//
//  DomainProduct+CoreDataClass.swift
//  
//
//  Created by Vladimir Banushkin on 21.03.2023.
//
//

import Foundation
import CoreData

@objc(DomainProduct)
public class DomainProduct: NSManagedObject {
    static func prepare(fromPlainModel model: Product, context: NSManagedObjectContext) -> DomainProduct {
        let product = DomainProduct(context: context)
        product.id = model.id
        product.isUserProduct = model.isUserProduct
        product.title = model.title
        product.brand = model.brand
        product.barcode = model.barcode
        product.kcal = model.kcal
        product.fat = model.fat
        product.carbs = model.carbs
        product.protein = model.protein
        product.ketoRating = model.ketoRating
        product.productURL = Int16(model.productURL ?? -1)
        product.photo = try? JSONEncoder().encode(model.photo)
        product.composition = try? JSONEncoder().encode(model.composition)
        product.servings = try? JSONEncoder().encode(model.servings)
        product.units = try? JSONEncoder().encode(model.units)
        let baseTags: [DomainExceptionTag] = model
            .baseTags
            .compactMap { DomainExceptionTag.prepare(from: $0, context: context) }
        product.addToExceptionTags(NSOrderedSet(array: baseTags))
        product.createdAt = model.createdAt
        product.source = model.source
        return product
    }
    
}
