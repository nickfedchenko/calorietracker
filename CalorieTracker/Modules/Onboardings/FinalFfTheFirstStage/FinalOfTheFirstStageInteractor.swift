//
//  FinalOfTheFirstStageInteractor.swift
//  CalorieTracker
//
//  Created by Алексей on 23.08.2022.
//

import Foundation

protocol FinalOfTheFirstStageInteractorInterface: AnyObject {}

class FinalOfTheFirstStageInteractor {
    weak var presenter: FinalOfTheFirstStagePresenterInterface?
}

extension FinalOfTheFirstStageInteractor: FinalOfTheFirstStageInteractorInterface {}
