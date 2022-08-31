//
//  YoureNotAloneInteractor.swift
//  CalorieTracker
//
//  Created by Алексей on 30.08.2022.
//

import Foundation

protocol YoureNotAloneInteractorInterface: AnyObject {}

class YoureNotAloneInteractor {
    
    // MARK: - Public properties
    
    weak var presenter: YoureNotAlonePresenterInterface?
}

extension YoureNotAloneInteractor: YoureNotAloneInteractorInterface {}
