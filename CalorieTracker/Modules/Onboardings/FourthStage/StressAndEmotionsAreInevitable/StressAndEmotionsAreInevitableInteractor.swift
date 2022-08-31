//
//  StressAndEmotionsAreInevitableInteractor.swift
//  CalorieTracker
//
//  Created by Алексей on 30.08.2022.
//

import Foundation

protocol StressAndEmotionsAreInevitableInteractorInterface: AnyObject {}

class StressAndEmotionsAreInevitableInteractor {
    
    // MARK: - Public properties
    
    weak var presenter: StressAndEmotionsAreInevitablePresenterInterface?
}

// MARK: - StressAndEmotionsAreInevitableInteractorInterface

extension StressAndEmotionsAreInevitableInteractor: StressAndEmotionsAreInevitableInteractorInterface {}
