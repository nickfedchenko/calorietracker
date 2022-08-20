//
//  WelcomeInterctor.swift
//  CalorieTracker
//
//  Created by Алексей on 19.08.2022.
//

import Foundation

protocol WelcomeInterctorInterface: AnyObject {}

class WelcomeInterctor {
    weak var presentor: WelcomePresentorInterface?
}

extension WelcomeInterctor: WelcomeInterctorInterface {}
