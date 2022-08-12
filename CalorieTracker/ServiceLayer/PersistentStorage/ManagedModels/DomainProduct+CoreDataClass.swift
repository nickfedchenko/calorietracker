//
//  DomainProduct+CoreDataClass.swift
//  
//
//  Created by Vladimir Banushkin on 11.08.2022.
//
//

import CoreData

@objc(DomainProduct)
public class DomainProduct: NSManagedObject {
    static func prepare(fromPlainModel model: Product, context: NSManagedObjectContext) -> DomainProduct {
        let product = DomainProduct(context: context)
        product.id = Int16(model.id)
        product.barcode = model.barcode
        product.title = model.title
        product.protein = model.protein
        product.fat = model.fat
        product.carbs = model.carbs
        product.kcal = Int16(model.kcal)
        product.photo = model.photo
        product.composition = try? JSONEncoder().encode(model.composition)
        product.brand = model.brand
        product.servings = try? JSONEncoder().encode(model.servings)
        product.isBasic = model.isBasic ?? false
        product.isDished = model.isDished ?? false
        product.isBasicState = model.isBasicState ?? false
        return product
    }
}
