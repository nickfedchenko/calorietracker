//
//  YourHeightInteractor.swift
//  CalorieTracker
//
//  Created by Алексей on 28.08.2022.
//

import Foundation

protocol YourHeightInteractorInterface: AnyObject {}

class YourHeightInteractor {
    
    // MARK: - Public properties
    
    weak var presenter: YourHeightPresenterInterface?
}

// MARK: - YourHeightInteractorInterface

extension YourHeightInteractor: YourHeightInteractorInterface {}
