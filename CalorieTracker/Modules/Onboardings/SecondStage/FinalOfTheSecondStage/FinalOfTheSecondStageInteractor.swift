//
//  FinalOfTheSecondStageInteractor.swift
//  CalorieTracker
//
//  Created by Алексей on 28.08.2022.
//

import Foundation

protocol FinalOfTheSecondStageInteractorInterface: AnyObject {}

class FinalOfTheSecondStageInteractor {
    
    // MARK: - Public properties

    weak var presenter: FinalOfTheSecondStagePresenterInterface?
}

// MARK: - FinalOfTheSecondStageInteractorInterface

extension FinalOfTheSecondStageInteractor: FinalOfTheSecondStageInteractorInterface {}
