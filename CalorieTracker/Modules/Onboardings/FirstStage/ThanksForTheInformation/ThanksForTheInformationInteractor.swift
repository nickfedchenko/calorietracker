//
//  ThanksForTheInformationInteractor.swift
//  CalorieTracker
//
//  Created by Алексей on 23.08.2022.
//

import Foundation

protocol ThanksForTheInformationInteractorInterface: AnyObject {}

class ThanksForTheInformationInteractor {
    
    // MARK: - Public properties

    weak var presenter: ThanksForTheInformationPresenterInterface?
}

// MARK: - ThanksForTheInformationInteractorInterface

extension ThanksForTheInformationInteractor: ThanksForTheInformationInteractorInterface {}
