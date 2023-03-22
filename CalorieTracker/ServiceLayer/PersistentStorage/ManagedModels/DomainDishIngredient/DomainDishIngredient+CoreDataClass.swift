//
//  DomainDishIngredient+CoreDataClass.swift
//  
//
//  Created by Vladimir Banushkin on 21.03.2023.
//
//

import CoreData

@objc(DomainDishIngredient)
public class DomainDishIngredient: NSManagedObject {
    static func prepare(
        from plainModel: Ingredient,
        context: NSManagedObjectContext
    ) -> DomainDishIngredient? {
        let domainIngredient = DomainDishIngredient(context: context)
        domainIngredient.id = Int32(plainModel.id)
        domainIngredient.productID = Int32(plainModel.product.id)
        if let unit = plainModel.unit {
            domainIngredient.unitID = Int32(unit.id)
            domainIngredient.unitTitle = unit.title
            domainIngredient.unitShorTitle = unit.shortTitle
            domainIngredient.unitIsOnlyForMarket = unit.isOnlyForMarket
        } else {
           return nil
        }
        domainIngredient.quantity = plainModel.quantity
        domainIngredient.isNamed = plainModel.isNamed
        return domainIngredient
    }

    var product: Product? {
        FDS.shared.getProduct(by: String(productID))
    }
}
