//
//  ObsessingOverFoodInteractor.swift
//  CalorieTracker
//
//  Created by Алексей on 23.08.2022.
//

import Foundation

protocol ObsessingOverFoodInterctorInterface: AnyObject {}

class ObsessingOverFoodInteractor {
    weak var presenter: ObsessingOverFoodPresenterInterface?
}

extension ObsessingOverFoodInteractor: ObsessingOverFoodInterctorInterface {}
