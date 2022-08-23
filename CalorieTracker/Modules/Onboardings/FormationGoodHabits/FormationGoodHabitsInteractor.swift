//
//  FormationGoodHabitsInteractor.swift
//  CalorieTracker
//
//  Created by Алексей on 23.08.2022.
//

import Foundation

import Foundation

protocol FormationGoodHabitsInteractorInterface: AnyObject {}

class FormationGoodHabitsInteractor {
    weak var presenter: FormationGoodHabitsPresenterInterface?
}

extension FormationGoodHabitsInteractor: FormationGoodHabitsInteractorInterface {}
