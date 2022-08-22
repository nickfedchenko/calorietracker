//
//  CalorieCountInteractor.swift
//  CalorieTracker
//
//  Created by Алексей on 22.08.2022.
//

import Foundation

protocol CalorieCountInteractorInterface: AnyObject {}

class CalorieCountInteractor {
    weak var presenter: CalorieCountPresenterInterface?
}

extension CalorieCountInteractor: CalorieCountInteractorInterface
