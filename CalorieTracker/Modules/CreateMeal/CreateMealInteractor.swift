//
//  CreateMealInteractor.swift
//  CIViperGenerator
//
//  Created by Alexandru Jdanov on 27.02.2023.
//  Copyright © 2023 Alexandru Jdanov. All rights reserved.
//

import Foundation

protocol CreateMealInteractorInterface: AnyObject {

}

class CreateMealInteractor {
    weak var presenter: CreateMealPresenterInterface?
}

extension CreateMealInteractor: CreateMealInteractorInterface {

}
