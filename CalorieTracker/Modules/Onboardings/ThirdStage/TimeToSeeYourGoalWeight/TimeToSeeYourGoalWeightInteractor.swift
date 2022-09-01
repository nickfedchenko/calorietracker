//
//  TimeToSeeYourGoalWeightInteractor.swift
//  CalorieTracker
//
//  Created by Алексей on 29.08.2022.
//

import Foundation

protocol TimeToSeeYourGoalWeightInteractorInterface: AnyObject {}

class TimeToSeeYourGoalWeightInteractor {
    
    // MARK: - Public properties
    
    weak var presenter: TimeToSeeYourGoalWeightPresenterInterface?
}

// MARK: - TimeToSeeYourGoalWeightInteractorInterface

extension TimeToSeeYourGoalWeightInteractor: TimeToSeeYourGoalWeightInteractorInterface {}
