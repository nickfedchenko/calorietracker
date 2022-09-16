//
//  FinalOfTheFourthStageInteractor.swift
//  CalorieTracker
//
//  Created by Алексей on 31.08.2022.
//

import Foundation

protocol FinalOfTheFourthStageInteractorInterface: AnyObject {}

class FinalOfTheFourthStageInteractor {
    
    // MARK: - Public properties
    
    weak var presenter: FinalOfTheFourthStagePresenterInterface?
}

// MARK: - FinalOfTheFourthStageInteractorInterface

extension FinalOfTheFourthStageInteractor: FinalOfTheFourthStageInteractorInterface {}
