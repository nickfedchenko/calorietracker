//
//  GetStartedInteractor.swift
//  CalorieTracker
//
//  Created by Алексей on 19.08.2022.
//

import Foundation

protocol GetStartedInteractorInterface: AnyObject {}

class GetStartedInteractor {
    weak var presenter: GetStartedPresenterInterface?
}

extension GetStartedInteractor: GetStartedInteractorInterface {}
