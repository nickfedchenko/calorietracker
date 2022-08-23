//
//  PreviousApplicationInteractor.swift
//  CalorieTracker
//
//  Created by Алексей on 22.08.2022.
//

import Foundation

protocol PreviousApplicationInteractorInterface: AnyObject {}

class PreviousApplicationInteractor {
    weak var presenter: PreviousApplicationPresenterInterface?
}

extension PreviousApplicationInteractor: PreviousApplicationInteractorInterface {}
