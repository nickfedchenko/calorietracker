//
//  DomainMealComponent+CoreDataProperties.swift
//  
//
//  Created by Vladimir Banushkin on 12.03.2023.
//
//

import CoreData

extension DomainMealComponent {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<DomainMealComponent> {
        return NSFetchRequest<DomainMealComponent>(entityName: "DomainMealComponent")
    }
    
    @NSManaged public var dishID: String?
    @NSManaged public var productID: String?
    @NSManaged public var customEntryID: String?
    @NSManaged public var dishAmount: Double
    @NSManaged public var productAmount: Double
    @NSManaged public var mealComponentId: String?
    @NSManaged public var meal: DomainMeal?
    @NSManaged public var productUnitID: Int32
    
    var product: Product? {
        if let productID = productID {
            if let product = FDS.shared.getProduct(by: productID) {
                return product
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    var dish: Dish? {
        if let dishID = dishID {
            if let dish = FDS.shared.getDish(by: dishID) {
                return dish
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    var customEntry: CustomEntry? {
        if let customEntryID = customEntryID {
            if let entry = FDS.shared.getCustomEntry(by: customEntryID) {
                return entry
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
}
