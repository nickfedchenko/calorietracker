//
//  WelcomeInterctor.swift
//  CalorieTracker
//
//  Created by Алексей on 19.08.2022.
//

import Foundation

protocol WelcomeInterctorInterface: AnyObject {}

class WelcomeInteractor {
    weak var presenter: WelcomePresenterInterface?
}

extension WelcomeInteractor: WelcomeInterctorInterface {}
