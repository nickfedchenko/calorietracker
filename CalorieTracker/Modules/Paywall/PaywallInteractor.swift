//
//  PaywallInteractor.swift
//  CalorieTracker
//
//  Created by Алексей on 08.09.2022.
//

import Foundation

protocol PaywallInteractorInterface: AnyObject {}

class PaywallInteractor {
    
    // MARK: - Public properties
    
    weak var presenter: PaywallPresenterInterface?
}

// MARK: - PaywallInteractorInterface

extension PaywallInteractor: PaywallInteractorInterface {}
