//
//  TheEffectOfWeightInteractor.swift
//  CalorieTracker
//
//  Created by Алексей on 23.08.2022.
//

import Foundation

protocol TheEffectOfWeightInteractorInterface: AnyObject {}

class TheEffectOfWeightInteractor {
    weak var presenter: TheEffectOfWeightPresenterInterface?
}

extension TheEffectOfWeightInteractor: TheEffectOfWeightInteractorInterface {}
