//
//  ProductInteractor.swift
//  CIViperGenerator
//
//  Created by Mov4D on 15.11.2022.
//  Copyright © 2022 Mov4D. All rights reserved.
//

import Foundation

protocol ProductInteractorInterface: AnyObject {
    func updateFoodData(_ flag: Bool?)
    func getProduct() -> Product?
}

class ProductInteractor {
    weak var presenter: ProductPresenterInterface?
    var product: Product?
}

extension ProductInteractor: ProductInteractorInterface {
    func getProduct() -> Product? {
        return product
    }
    
    func updateFoodData(_ flag: Bool?) {
        guard let product = product else {
            return
        }
        
        self.product?.foodDataId = FDS.shared.foodUpdate(
            food: .product(product),
            favorites: flag
        )
    }
}
