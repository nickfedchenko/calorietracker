//
//  DifficultyOfMakingHealthyChoicesInteractor.swift
//  CalorieTracker
//
//  Created by Алексей on 31.08.2022.
//

import Foundation

protocol DifficultyOfMakingHealthyChoicesInteractorInterface: AnyObject {}

class DifficultyOfMakingHealthyChoicesInteractor {
    
    // MARK: - Public properties
    
    weak var presenter: DifficultyOfMakingHealthyChoicesPresenterInterface?
}

extension DifficultyOfMakingHealthyChoicesInteractor: DifficultyOfMakingHealthyChoicesInteractorInterface {}
