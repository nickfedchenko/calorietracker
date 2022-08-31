//
//  HealthAppInteractor.swift
//  CalorieTracker
//
//  Created by Алексей on 31.08.2022.
//

import Foundation

protocol HealthAppInteractorInterface: AnyObject {}

class HealthAppInteractor {
    
    // MARK: - Public properties
    
    weak var presenter: HealthAppPresenterInterface?
}

extension HealthAppInteractor: HealthAppInteractorInterface {}
