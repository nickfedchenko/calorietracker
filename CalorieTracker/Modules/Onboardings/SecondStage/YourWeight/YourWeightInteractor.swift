//
//  YourWeightInteractor.swift
//  CalorieTracker
//
//  Created by Алексей on 28.08.2022.
//

import Foundation

protocol YourWeightInteractorInterface: AnyObject {}

class YourWeightInteractor {
    
    // MARK: - Public properties
    
    weak var presenter: YourWeightPresenterInterface?
}

extension YourWeightInteractor: YourWeightInteractorInterface {}
