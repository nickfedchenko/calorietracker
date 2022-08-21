//
//  PurposeOfTheParishInteractor.swift
//  CalorieTracker
//
//  Created by Алексей on 21.08.2022.
//

import Foundation

protocol PurposeOfTheParishInteractorInterface: AnyObject {}

class PurposeOfTheParishInteractor {
    weak var presenter: PurposeOfTheParishInteractorInterface?
}

extension PurposeOfTheParishInteractor: PurposeOfTheParishInteractorInterface {}
