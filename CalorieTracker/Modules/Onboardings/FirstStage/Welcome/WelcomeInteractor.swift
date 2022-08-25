//
//  WelcomeInterctor.swift
//  CalorieTracker
//
//  Created by Алексей on 19.08.2022.
//

import Foundation

protocol WelcomeInterctorInterface: AnyObject {}

class WelcomeInteractor {
    
    // MARK: - Public properties
    
    weak var presenter: WelcomePresenterInterface?
}

// MARK: - WelcomeInterctorInterface

extension WelcomeInteractor: WelcomeInterctorInterface {}
