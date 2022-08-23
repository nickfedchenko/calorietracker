//
//  RecentWeightChangesInteractor.swift
//  CalorieTracker
//
//  Created by Алексей on 21.08.2022.
//

import Foundation

protocol RecentWeightChangesInteractorInterface: AnyObject {}

class RecentWeightChangesInteractor {
    weak var presenter: RecentWeightChangesPresenterInterface?
}

extension RecentWeightChangesInteractor: RecentWeightChangesInteractorInterface {}
