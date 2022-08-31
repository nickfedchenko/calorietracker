//
//  HelpingPeopleTrackCaloriesInteractor.swift
//  CalorieTracker
//
//  Created by Алексей on 30.08.2022.
//

import Foundation

protocol HelpingPeopleTrackCaloriesInteractorInterface: AnyObject {}

class HelpingPeopleTrackCaloriesInteractor {
    
    // MARK: - Public properties
    
    weak var presenter: HelpingPeopleTrackCaloriesPresenterInterface?
}

// MARK: - HelpingPeopleTrackCaloriesInteractorInterface

extension HelpingPeopleTrackCaloriesInteractor: HelpingPeopleTrackCaloriesInteractorInterface {}
