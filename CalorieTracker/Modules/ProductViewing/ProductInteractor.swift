//
//  ProductInteractor.swift
//  CIViperGenerator
//
//  Created by Mov4D on 15.11.2022.
//  Copyright © 2022 Mov4D. All rights reserved.
//

import Foundation

protocol ProductInteractorInterface: AnyObject {

}

class ProductInteractor {
    weak var presenter: ProductPresenterInterface?
}

extension ProductInteractor: ProductInteractorInterface {

}
