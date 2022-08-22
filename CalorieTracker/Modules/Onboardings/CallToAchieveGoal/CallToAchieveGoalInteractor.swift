//
//  CallToAchieveGoalInteractor.swift
//  CalorieTracker
//
//  Created by Алексей on 22.08.2022.
//

import Foundation

protocol CallToAchieveGoalInteractorInterface: AnyObject {}

class CallToAchieveGoalInteractor {
    weak var presenter: CallToAchieveGoalPresenterInterface?
}

extension CallToAchieveGoalInteractor: CallToAchieveGoalInteractorInterface {}
