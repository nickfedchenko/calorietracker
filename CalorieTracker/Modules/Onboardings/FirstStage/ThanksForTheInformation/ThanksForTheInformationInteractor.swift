//
//  ThanksForTheInformationInteractor.swift
//  CalorieTracker
//
//  Created by Алексей on 23.08.2022.
//

import Foundation

protocol ThanksForTheInformationInteractorInterface: AnyObject {}

class ThanksForTheInformationInteractor {
    weak var presenter: ThanksForTheInformationPresenterInterface?
}

extension ThanksForTheInformationInteractor: ThanksForTheInformationInteractorInterface {}
