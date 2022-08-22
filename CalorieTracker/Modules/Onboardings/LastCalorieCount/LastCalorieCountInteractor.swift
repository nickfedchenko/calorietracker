//
//  LastCalorieCountInteractor.swift
//  CalorieTracker
//
//  Created by Алексей on 22.08.2022.
//

import Foundation

protocol LastCalorieCountInteractorInterface: AnyObject {}

class LastCalorieCountInteractor {
    weak var presenter: LastCalorieCountPresenterInterface?
}

extension LastCalorieCountInteractor: LastCalorieCountInteractorInterface {}
