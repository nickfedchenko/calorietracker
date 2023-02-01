//
//  DomainUserProduct+CoreDataClass.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 23.11.2022.
//

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
        
        product.photo = try? JSONEncoder().encode(model.photo)
        product.composition = try? JSONEncoder().encode(model.composition)
        product.servings = try? JSONEncoder().encode(model.servings)
        product.units = try? JSONEncoder().encode(model.units)
        return product
    }
}
