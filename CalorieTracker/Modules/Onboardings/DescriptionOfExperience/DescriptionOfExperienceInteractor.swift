//
//  DescriptionOfExperienceInteractor.swift
//  CalorieTracker
//
//  Created by Алексей on 20.08.2022.
//

import Foundation

protocol DescriptionOfExperienceInteractorInterface: AnyObject {}

class DescriptionOfExperienceInteractor {
    weak var presentor: DescriptionOfExperiencePresenterInterface?
}

extension DescriptionOfExperienceInteractor: DescriptionOfExperienceInteractorInterface {}
