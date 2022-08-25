//
//  GetStartedInteractor.swift
//  CalorieTracker
//
//  Created by Алексей on 19.08.2022.
//

import Foundation

protocol GetStartedInteractorInterface: AnyObject {}

class GetStartedInteractor {
    
    // MARK: - Public properties
    
    weak var presenter: GetStartedPresenterInterface?
}

// MARK: - GetStartedInteractorInterface

extension GetStartedInteractor: GetStartedInteractorInterface {}
