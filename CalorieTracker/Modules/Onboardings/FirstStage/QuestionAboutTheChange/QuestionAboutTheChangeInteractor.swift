//
//  QuestionAboutTheChangeInteractor.swift
//  CalorieTracker
//
//  Created by Алексей on 22.08.2022.
//

import Foundation

protocol QuestionAboutTheChangeInteractorInterface: AnyObject {}

class QuestionAboutTheChangeInteractor {
    weak var presenter: QuestionAboutTheChangePresenterInterface?
}

extension QuestionAboutTheChangeInteractor: QuestionAboutTheChangeInteractorInterface {}
