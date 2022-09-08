//
//  CalorieTrackingViaKcalcInteractor.swift
//  CalorieTracker
//
//  Created by Алексей on 31.08.2022.
//

import Foundation

protocol CalorieTrackingViaKcalcInteractorInterface: AnyObject {}

class CalorieTrackingViaKcalcInteractor {
    
    // MARK: - Public properties
    
    weak var presenter: CalorieTrackingViaKcalcPresenterInterface?
}

// MARK: - CalorieTrackingViaKcalcInteractorInterface

extension CalorieTrackingViaKcalcInteractor: CalorieTrackingViaKcalcInteractorInterface {}
