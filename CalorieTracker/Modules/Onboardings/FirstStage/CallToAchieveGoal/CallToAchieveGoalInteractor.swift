//
//  CallToAchieveGoalInteractor.swift
//  CalorieTracker
//
//  Created by Алексей on 22.08.2022.
//

import Foundation

protocol CallToAchieveGoalInteractorInterface: AnyObject {}

class CallToAchieveGoalInteractor {
    
    // MARK: - Public properties
    
    weak var presenter: CallToAchieveGoalPresenterInterface?
}

// MARK: - CallToAchieveGoalInteractorInterface

extension CallToAchieveGoalInteractor: CallToAchieveGoalInteractorInterface {}
