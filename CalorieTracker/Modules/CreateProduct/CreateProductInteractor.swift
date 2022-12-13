//
//  CreateProductInteractor.swift
//  CIViperGenerator
//
//  Created by Mov4D on 11.12.2022.
//  Copyright © 2022 Mov4D. All rights reserved.
//

import Foundation

protocol CreateProductInteractorInterface: AnyObject {
    
}

class CreateProductInteractor {
    weak var presenter: CreateProductPresenterInterface?
}

extension CreateProductInteractor: CreateProductInteractorInterface {
    
}
