//
//  SoundsGoodInteractor.swift
//  CalorieTracker
//
//  Created by Алексей on 30.08.2022.
//

import Foundation

protocol SoundsGoodInteractorInterface: AnyObject {}

class SoundsGoodInteractor {
    
    // MARK: - Public properties
    
    weak var presenter: SoundsGoodPresenterInterface?
}

// MARK: - SoundsGoodInteractorInterface

extension SoundsGoodInteractor: SoundsGoodInteractorInterface {}
