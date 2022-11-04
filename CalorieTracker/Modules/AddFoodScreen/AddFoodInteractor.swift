//
//  AddFoodInteractor.swift
//  CIViperGenerator
//
//  Created by Mov4D on 28.10.2022.
//  Copyright © 2022 Mov4D. All rights reserved.
//

import Foundation

protocol AddFoodInteractorInterface: AnyObject {

}

class AddFoodInteractor {
    weak var presenter: AddFoodPresenterInterface?
}

extension AddFoodInteractor: AddFoodInteractorInterface {

}
