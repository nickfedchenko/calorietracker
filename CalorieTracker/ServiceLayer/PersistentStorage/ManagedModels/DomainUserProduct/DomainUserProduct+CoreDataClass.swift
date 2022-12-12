//
//  DomainUserProduct+CoreDataClass.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 23.11.2022.
//

import CoreData

@objc(DomainUserProduct)
public class DomainUserProduct: NSManagedObject {
    static func prepare(fromPlainModel model: Product, context: NSManagedObjectContext) -> DomainUserProduct {
        let product = DomainUserProduct(context: context)
        product.id = model.id
        product.title = model.title
        product.brand = model.brand
        product.barcode = model.barcode
        product.kcal = model.kcal
        product.fat = model.fat
        product.carbs = model.carbs
        product.protein = model.protein
        
        product.photo = {
            switch model.photo {
            case .data(let data):
                return data
            default:
                return nil
            }
        }()
        
        product.composition = try? JSONEncoder().encode(model.composition)
        product.servings = try? JSONEncoder().encode(model.servings)
        
        return product
    }
}
