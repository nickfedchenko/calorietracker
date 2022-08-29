//
//  ReflectToAchievedSomethingDifficultInteractor.swift
//  CalorieTracker
//
//  Created by Алексей on 29.08.2022.
//

import Foundation

protocol ReflectToAchievedSomethingDifficultInteractorInterface: AnyObject {}

class ReflectToAchievedSomethingDifficultInteractor {
    
    // MARK: - Public properties
    
    weak var presenter: ReflectToAchievedSomethingDifficultPresenterInterface?
}

// MARK: - ReflectToAchievedSomethingDifficultInteractorInterface

extension ReflectToAchievedSomethingDifficultInteractor: ReflectToAchievedSomethingDifficultInteractorInterface {}
