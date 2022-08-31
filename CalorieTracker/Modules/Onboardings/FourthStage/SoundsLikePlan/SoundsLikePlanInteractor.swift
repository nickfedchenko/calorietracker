//
//  SoundsLikePlanInteractor.swift
//  CalorieTracker
//
//  Created by Алексей on 30.08.2022.
//

import Foundation

protocol SoundsLikePlanInteractorInterface: AnyObject {}

class SoundsLikePlanInteractor {
    
    // MARK: - Public properties
    
    weak var presenter: SoundsLikePlanPresenterInterface?
}

// MARK: - SoundsLikePlanInteractorInterface

extension SoundsLikePlanInteractor: SoundsLikePlanInteractorInterface {}
