//
//  QuestionOfLosingWeightInteractor.swift
//  CalorieTracker
//
//  Created by Алексей on 20.08.2022.
//

import Foundation

protocol QuestionOfLosingWeightInteractorInterface: AnyObject {}

class QuestionOfLosingWeightInteractor {
    weak var presentor: QuestionOfLosingWeightPresentorInterface?
}

extension QuestionOfLosingWeightInteractor: QuestionOfLosingWeightInteractorInterface {}
